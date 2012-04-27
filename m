Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2D0WXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:23:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54825 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2D0WXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:23:38 -0400
Message-ID: <4F9B1C55.50004@linaro.org>
Date: Fri, 27 Apr 2012 15:23:17 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap second
References: <cover.1335442155.git.richardcochran@gmail.com> <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
In-Reply-To: <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042722-3270-0000-0000-000005E4DDFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 05:11 AM, Richard Cochran wrote:
> When repeating a UTC time value during a leap second (when the UTC
> time should be 23:59:60), the TAI timescale should not stop. The kernel
> NTP code increments the TAI offset one second too late. This patch fixes
> the issue by incrementing the offset during the leap second itself.
>
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>

This looks good to me. Although, have you actually tested against an ntp 
client that sets the tai offset to make sure you're not duplicating any 
ADJ_TAI adjustment it might make?

thanks
-john


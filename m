Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2F1HAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:00:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2F1HAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:00:07 -0400
Message-ID: <4FEC00EE.7040007@canonical.com>
Date: Thu, 28 Jun 2012 14:59:58 +0800
From: Alex Hung <alex.hung@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-wmi: change wireless key event to toggle all wireless
 devices.
References: <1340162788-531-1-git-send-email-alex.hung@canonical.com> <20120626183349.GB29375@srcf.ucam.org>
In-Reply-To: <20120626183349.GB29375@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 02:33 AM, Matthew Garrett wrote:
> Is this the expected behaviour (ie, is this what happens on Windows as
> well)?
>

Windows has an hotkey application called ATK. When Fn+F2 is pressed, it 
displays options for turning on/off for WLAN and Bluebooth.

ASUS agreed this is better as the previous code only turns off WLAN and 
there is no way to turn off Bluetooth.

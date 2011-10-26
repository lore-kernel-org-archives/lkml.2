Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1JZVXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:23:13 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:35037 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1JZVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:23:11 -0400
Message-ID: <4EA87A2F.9080408@genband.com>
Date: Wed, 26 Oct 2011 15:22:55 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Additional ALPS touchpad protocol support
References: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2011 21:22:57.0203 (UTC) FILETIME=[6E4B4830:01CC9425]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18474.001
X-TM-AS-Result: No--7.623000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 03:14 PM, Seth Forshee wrote:
> This patch series adds support for two ALPS touchpad protocol versions
> currently unsupported by the driver, which I've arbitrarily called
> versions 3 and 4 (with the two currently supported protocol versions
> changed to be called versions 1 and 2). The v3 touchpads are commonly
> found on Dell laptops, and the v4 touchpads are found on machines from a
> variety of other manufacturers.

Thanks for doing this!  Here's hoping it fixes my Dell.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com

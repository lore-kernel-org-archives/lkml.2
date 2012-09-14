Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2INORb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:17:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64761 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab2INORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:17:23 -0400
Message-ID: <50533C27.2040100@mvista.com>
Date: Fri, 14 Sep 2012 18:16:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: navin patidar <navinp@cdac.in>
CC: gregkh@linuxfoundation.org, mfm@muteddisk.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
References: <1347616403-3413-1-git-send-email-navinp@cdac.in> <50531832.3050902@mvista.com> <CAPV97yfV27x8hB2WUCVmGWEU7i21Y5K5trig2fzQBx+VB_Yk2g@mail.gmail.com>
In-Reply-To: <CAPV97yfV27x8hB2WUCVmGWEU7i21Y5K5trig2fzQBx+VB_Yk2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/14/2012 04:36 PM, navin patidar wrote:

> hi Sergei,
> checkpatch.pl <http://checkpatch.pl> didn't complain any thing about patch
> coding style.

   checkpatch.pl only complains about // comments, IIRC. But see
Documentation/CodingStyle chapter 8 about multi-line comments. As for adding
spaces, it's more for aesthetic reasons...

> Anyway  thanks for reviewing the patch.
> i will send this patch again with corrections.

  Thanks you.

> --navin-patidar

WBR, Sergei


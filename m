Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab0CSTQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:16:47 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46621 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0CSTQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oDSKfrLWsi7dBv2n1hXJRNwbg5/QE1bGx8ovqOj2AihdYP87OIg64R1k4oFBPa1u6w
         Qy4EE7HRb2A4XHrnSYNEH497aiMhI0jva2IrSm3MNMNnrUw/S0CDfJFVf4KEKcHKhKsA
         QZauD8/ubkBhJOUwRCStudNX7ISNkAOdBM5a4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc1: lockdep warning on geode subnotebook
Date: Fri, 19 Mar 2010 20:16:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; i686; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20100313105109.GA9966@elf.ucw.cz>
In-Reply-To: <20100313105109.GA9966@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003192016.36458.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 13 marca 2010 o 11:51:09 Pavel Machek wrote:
> sysfs related? ACPI?
> 
> Switching to clocksource acpi_pm
> Switched to NOHz mode on CPU #0
> BUG: key df3f6edc not in .data!

I created a Bugzilla entry at  
https://bugzilla.kernel.org/show_bug.cgi?id=15584
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl

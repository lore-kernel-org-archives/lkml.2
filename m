Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0GLPf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:35:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0GLPfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZvKthcN53cvJcbuwiIwCo65kkkCHBWlmb/pN1nxRjWkjJVVxV+q4M0DYDvfXBqAOUq
         ur3ZFuk35LVUmDIyPd/svrBNfZ1TgmulZfTYk41nT6DQIe53XEWlYo67ncuApnRnEDUt
         Jg0OR1r3LDK5jo7M1sW30faVxaXgC9m9OFRos=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: HDD not suspending properly / dead on resume
Date: Mon, 12 Jul 2010 17:35:06 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4; KDE/4.4.4; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@lists.osdl.org, stephan.diestelhorst@gmail.com
References: <201007091750.05020.stephan.diestelhorst@amd.com>
In-Reply-To: <201007091750.05020.stephan.diestelhorst@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007121735.07244.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 9 lipca 2010 o 17:50:04 Stephan Diestelhorst wrote:
> Hi,
>   I have n issue with suepnd to RAM and I/O load on a disk. Symptoms
> are that the disk does not respond to requests when woken up, producing
> only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
> mainline PPA build)):
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16370
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl

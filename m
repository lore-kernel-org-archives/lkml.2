Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab0DAS6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:58:50 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56837 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab0DAS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vboMP6O2+76WML8/LmF6Eu5mZqoj61Vlo6cNdlrbuBFbFmP4GbLr/yt7XEli0jA5o7
         G5LWCL8TdwtKnzPSMbIPYcqm/dGvNzkNnR26lDXNsFlwLgzev1mT5gHqeW5Xne2IROLf
         eGbiOexWcNDUxw0PXcwVry4AQqUzF4FuJYVhs=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: KVM bug, git bisected
Date: Thu, 1 Apr 2010 20:58:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, riel@redhat.com
References: <4BADFD74.8060904@gmail.com>
In-Reply-To: <4BADFD74.8060904@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012058.43449.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 27 marca 2010 o 13:43:32 Kent Overstreet wrote:
> commit 5beb49305251e5669852ed541e8e2f2f7696c53e
> Author: Rik van Riel <riel@redhat.com>
> Date:   Fri Mar 5 13:42:07 2010 -0800
> 
>      mm: change anon_vma linking to fix multi-process server scalability
> issue
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15672
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl

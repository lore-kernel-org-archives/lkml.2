Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0GASZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:25:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab0GASZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=r7qFRJtGBy2MOsC+7XPM35gRtNbJzXUNoAx67n1zsl3Z2FGFghhoNKdp3rEEQpzUSh
         ZqPsdPjUHKt2MlSCtlpiJcuO3kLMSDclZDV35w8HRqip1gEj7qG+EJGaWsQY3xgJzQs4
         OcEkgg+l1ErHdaYCeTTcGawkbmQV7t/0PzK0c=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: divya <dipraksh@linux.vnet.ibm.com>
Subject: Re: Oops while running fs_racer test on a POWER6 box against latest git
Date: Thu, 1 Jul 2010 20:25:30 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-git4; KDE/4.4.4; i686; ; )
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
References: <4C2B28F3.7000006@linux.vnet.ibm.com>
In-Reply-To: <4C2B28F3.7000006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007012025.30452.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 30 czerwca 2010 o 13:22:27 divya wrote:
> While running fs_racer test from LTP on a POWER6 box against latest
> git(2.6.35-rc3-git4 - commitid 984bc9601f64fd) came across the following
> warning followed by multiple oops.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16324
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl

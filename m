Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab1DNTiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:38:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58014 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab1DNTiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lYv50bldjIpwdkhVgKMHIylH+l9aCofDxDDEdDxlpq21i1pr+HJQ2G9p2VrrrTbWce
         ObBwafl14dblXh+s5bhffPYOdnPPj2hSGEL4k4CNXAYl+ZUZjD2LROz6LSocir6HGSuH
         volO6JUtHCT3qBZr2VPUTZTx4ViG2/Kks+Psk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Lockdep splat in autofs with 2.6.39-rc2
Date: Thu, 14 Apr 2011 21:38:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
        Ian Kent <raven@themaw.net>
References: <20110407194403.GA29404@elliptictech.com> <201104132126.42050.maciej.rutecki@gmail.com> <20110413194300.GA674@elliptictech.com>
In-Reply-To: <20110413194300.GA674@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104142138.00274.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 13 kwietnia 2011 o 21:43:00 Nick Bowler wrote:
> On 2011-04-13 21:26 +0200, Maciej Rutecki wrote:
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=33242 for your bug report,
> > please add your address to the CC list in there, thanks!
> 
> Unfortunately, that site does not appear to let me add this email to the
> CC list:
> 
>   Kernel Bug Tracker was unable to make any match at all for one or more
>   of the names and/or email addresses you entered on the previous page.
>   Please go back and try other names or email addresses.
> 
>   CC: nbowler@elliptictech.com did not match anything

Firstly you should create account in Bugzilla, then add your e-mail to CC. 
That is the reason why I ask you to put email -- I can't do it for you.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl

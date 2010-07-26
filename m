Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0GZPKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:10:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37768 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0GZPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ILGby2zfpbKEzEDN0aqX+fYJEXeOAwzZqbjc7py3DowOe1QhAMxLfwJw9SxZ+5LjUA
         +RlsahrdSKiaZoI0FUxIyeIQhN2KzMeQgdcBvIwfAEZy3/1inJIbmwF2NGF0apHV6Qhy
         XY5qt4TH/w4M9HKeLymm8VDGgBnLb9BOp2pU4=
Subject: Re: [RFC] [PATCH procfs] Add process age
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100726144848.GC17756@basil.fritz.box>
References: <1279907271.4335.3.camel@cowboy> <20100723183549.GA10518@x200>
	 <1279910830.1851.5.camel@cowboy> <87fwz6it0e.fsf@basil.nowhere.org>
	 <1280152668.2212.1.camel@cowboy>  <20100726144848.GC17756@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 11:10:29 -0400
Message-ID: <1280157029.2212.17.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 16:48 +0200, Andi Kleen wrote:
> > True, but there are also many other no-so-useful files under /proc that
> > can also be replaced by userspace apps.
> 
> Example? 

Off the top of my head:

/proc/cmdline
Several entries in /proc/#/status, like Name, PPid, Gid, Uid, etc.

I am not criticizing this, I think some repetitive data is good for
users. Just showing that other features can also be obtained from
userspace.

Davidlohr


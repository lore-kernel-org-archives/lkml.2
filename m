Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1DKXSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:18:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61546 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1DKXSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jr3Cz+qtlEQkaWeE5HvOqzAKXhBTU+qapiyN5AUQgwZv4x7m/UTm/Q3+IZdc818Bya
         GcS3JqIIWDZj0sNtzp6Tfa1hC/sjMnByjypHOCOD3ObF2HvFVBl+mEXrA3zC4t8cgSkV
         oHEwK1+4SAHw6kCTL8r9K/yo4id3KZC3Gt48A=
Date: Tue, 12 Apr 2011 01:18:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in 2.6.36
Message-ID: <20110411231843.GB2061@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
 <AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
 <201103311704.40372.roucaries.bastien@gmail.com>
 <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
 <4D9B3C10.9060704@suse.com>
 <BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
 <BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
 <BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
 <BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:40:18AM +0200, Bastien ROUCARIES wrote:
> Any news ? Can I test some patch ?
> 
> Bastien

I have a box currently running two parallel loops of git pull.
It has run for two hours now and nothing happened, I'm going to
let that wheel run the whole night and see tomorrow.

In the meantime I'm preparing another box with more CPUs to run
more parallel git pull. Hopefully I could stress it enough to
reproduce.

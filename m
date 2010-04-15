Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0DOVSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:18:32 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35445 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab0DOVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rPPqbyAL12jTz6FGa2UP/FZZTwEB30M5vxDJMPy3jb25oIY/7c75MwosbZ+RdSLOnF
         hnEsK3VsZ7+vV2VMX/fodSxlEwFhNTYtP01X3ubat9tYHIzavPIQeuudrRBGVpSNq6fb
         1g/8YHDPd3e+SlUPI4Iof53Q7hb8myp++3rQw=
Date: Thu, 15 Apr 2010 23:18:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs locking
Message-ID: <20100415211828.GH5069@nowhere>
References: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:02:22AM +0400, Alexander Beregalov wrote:
> Hi Frederic!
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.34-rc3-00410-gd620a7c #1


Thanks!

I'm going to look at this.


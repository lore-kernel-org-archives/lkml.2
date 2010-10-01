Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0JEMxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:53:24 -0400
Received: from kroah.org ([198.145.64.141]:52160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0JEMxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:53:23 -0400
Date: Fri, 1 Oct 2010 15:54:46 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Please promote to stable
Message-ID: <20101001225446.GA13750@kroah.com>
References: <4CA64CC1.5050702@zytor.com>
 <20101001221615.GA12589@kroah.com>
 <4CA662E2.4040509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA662E2.4040509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 03:38:26PM -0700, H. Peter Anvin wrote:
> On 10/01/2010 03:16 PM, Greg KH wrote:
> > On Fri, Oct 01, 2010 at 02:04:01PM -0700, H. Peter Anvin wrote:
> >> Please promote the following x86 patches to stable:
> >>
> >> 1dedefd1a066a795a87afca9c0236e1a94de9bf6
> >> d900329e20f4476db6461752accebcf7935a8055 [as soon as Linus merges it]
> >>
> >> The latter is already tagged stable.
> >>
> >> These two patches are needed to resolve kernel bugzilla 16322.
> > 
> > For .35 and .32, or only .35?
> > 
> 
> Both.

Thanks, will do.

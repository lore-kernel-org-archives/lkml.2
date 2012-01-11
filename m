Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2AKPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:14:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56355 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303Ab2AKPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:14:17 -0500
X-Sasl-enc: IaaSRYpRJAm/ZuFondrrT0JNc20GVpcoEKXlbOmIptNq 1326294856
Date: Wed, 11 Jan 2012 07:13:05 -0800
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Latest kernel stable/longterm status
Message-ID: <20120111151305.GC24077@kroah.com>
References: <20120110003705.GA9482@kroah.com>
 <CAMuHMdWHgQY-=43ReEOHgDtdAFhhOELaB8aNimV99+ud1Y=NCA@mail.gmail.com>
 <CAMuHMdVSQS0B_DotQytbmeBs0=a4=8NMhdG5UVXbWjBXYrykFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVSQS0B_DotQytbmeBs0=a4=8NMhdG5UVXbWjBXYrykFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 01:42:08PM +0100, Geert Uytterhoeven wrote:
> On Wed, Jan 11, 2012 at 13:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Jan 10, 2012 at 01:37, Greg KH <greg@kroah.com> wrote:
> >> First off, please everyone remember to mark any patch that you want to
> >> have applied to the stable kernel trees with a simple:
> >>        Cc: stable <stable@vger.kernel.org>
> >> marking in the Signed-off-by: area.  Once the patch hits Linus's tree, I
> >> will automatically be notified of it and it will be applied if possible.
> >> If it does not applied, you will be notified of that.
> >
> > How do you want us to specify to which versions it should be applied?
> 
> Cc: v3.2, v3.1, ... <stable@vger.kernel.org>

That can work, or if you read Documenation/stable_kernel_rules.txt you
can see some other ways to nicely do this :)

thanks,

greg k-h

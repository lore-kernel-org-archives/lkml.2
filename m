Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0HaT3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab0HaT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:29:37 -0400
Date: Tue, 31 Aug 2010 15:29:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100831192919.GB5759@shell>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:18:11PM +0200, Miklos Szeredi wrote:
> On Sun, 29 Aug 2010, Neil Brown wrote:
> 
> > My comment about set-theory unions being commutative set me thinking.  I
> > really don't think "union" is the right name for this thing.  There is
> > nothing about it which really fits that proper definition of a union.
> > whiteouts mean that even the list of names in a directory is not the union of
> > the lists of names in the upper and lower directories.
> > "overlay" is a much more accurate name.  But union seems to be the name
> > that is most used.  I wonder if it is too late to change that.
> 
> We could call it overlayfs.  People learn new names quickly :)

Union mounts was named "writable overlays" for one release in an
attempt to get away from the "arbitrary union of file systems" idea.
I think it helped, but went back to union mounts since it was more
familiar and made prettier function names.

The config option for union mounts says:

Union mounts allow you to mount a transparent writable layer over a
read-only file system, for example, an ext3 partition on a hard drive
over a CD-ROM root file system image.

-VAL

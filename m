Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0C0BDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab0C0BDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:03:32 -0400
Date: Fri, 26 Mar 2010 20:30:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jens.axboe@oracle.com,
       mrubin@google.com, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dpshah@google.com,
       Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 0/4] io-controller: Use names rather than major:minor
Message-ID: <20100327003037.GD9280@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> <4BAC0E7D.9080305@cn.fujitsu.com> <20100326152012.GB18128@redhat.com> <1786ab031003261554y40c21bc8sb4ea2f347c2c8bf8@mail.gmail.com> <20100327002056.GA9280@redhat.com> <20100327002404.GB9280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100327002404.GB9280@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 08:24:04PM -0400, Vivek Goyal wrote:
> On Fri, Mar 26, 2010 at 08:20:56PM -0400, Vivek Goyal wrote:
> 
> [..]
> > > Which controllers are these?
> > > 
> > 
> > linux-2.6/Documentation/cgroups/devices.txt
> > 
> > > > - Displaying both device major/minor and diskname is an option but that
> > > >  makes the file format syntax little complicated and new rule setting
> > > >  or removoal confusing.
> > > 
> > > A few messages back you mentioned that you preferred device names
> > > because they would be better for users of the system.  If there was a
> > > simple implementation, would you still be behind a new name-based
> > > interface?  We could go that direction and maintain ABI by deprecating
> > > current interface and making a new interface with names.
> > > 
> > > If you can't tell, I'm a big fan of using the name! :)  It's *much*
> > > more consistent with the interfaces in /sys.
> > 
> > /sys provides facility to access device both through device number
> > (/sys/dev/block/<major:minor>) and disk name (/sys/block/<diskname>). So
> > I don't know why do you think it is more consistent with /sys if we
> > use diskname.
> > 
> > In general user space seems to be accessing devices using device files.
> > For example, blockdev utility.
> 
> One more example is "blktrace".

Another example is "hdparm"

Vivek

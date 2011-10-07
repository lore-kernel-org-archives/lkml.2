Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab1JGNnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:43:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35468 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760028Ab1JGNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:43:34 -0400
Date: Fri, 7 Oct 2011 14:40:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, david@fubar.dk, greg@kroah.com,
        lennart@poettering.net, linux-kernel@vger.kernel.org,
        harald@redhat.com
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXM=?= Wish List for Linux
Message-ID: <20111007144027.3c785c76@lxorguk.ukuu.org.uk>
In-Reply-To: <CAE2SPAZci=u__d58phePCftVr_e+i+N2YU-JYjGDG_b3TmYTSQ@mail.gmail.com>
References: <CAE2SPAZci=u__d58phePCftVr_e+i+N2YU-JYjGDG_b3TmYTSQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011 15:09:16 +0200
Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> For fat a special xattr for root inode ?

If it's as Kay says a specific magic part of the directory and we need
this just as a fixup for FAT and NTFS then probably an ioctl on it will
do the job nicely. Sometimes stretching existing API's in semi-sane ways
actually gets to produce worse special cases (like tar restoring the
volume label by accident depending upon its settings)

Alan

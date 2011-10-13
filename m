Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1JMKCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:02:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35250 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754496Ab1JMKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:02:40 -0400
Date: Thu, 13 Oct 2011 11:01:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, hirofumi@mail.parknet.co.jp,
        linux-kernel@vger.kernel.org
Subject: Re: RFC : fat : default errors use FAT_ERRORS_CONT instead of
 FAT_ERRORS_RO.
Message-ID: <20111013110158.0b16341c@lxorguk.ukuu.org.uk>
In-Reply-To: <CAKYAXd--8=MkpXi0H4-nGF1vYQF42aL+OEjysg86gw83uyrefQ@mail.gmail.com>
References: <CAKYAXd9v_wFg2RQ_R+fYyCJnCbnuMs_VECujOen1GUSGXo3rHw@mail.gmail.com>
	<13498.1318467461@turing-police.cc.vt.edu>
	<CAKYAXd--8=MkpXi0H4-nGF1vYQF42aL+OEjysg86gw83uyrefQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If so, user can not write FAT filesystem anytime while using linux
> FAT.  there is no mehod except they should directly remount fat
> parittion. well known linux user can do it only.

That is a user space tools problem. Nothing stops a desktop doing things
like allowing you to click on a device and have a 'repair' menu entry
when appropriate. We have a FAT fsck (although neither it nor the
Microsoft one are brilliant at rescuing FAT disks) and the OS supports
mount/unmount/remount.

Alan

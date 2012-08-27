Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2H0WiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:38:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34927 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab2H0Wh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:37:59 -0400
Date: Mon, 27 Aug 2012 23:42:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] drivers:tty:fix up ENOIOCTLCMD error handling
Message-ID: <20120827234231.18b971f5@pyramind.ukuu.org.uk>
In-Reply-To: <1346052196-32682-2-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1346052196-32682-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012 15:23:12 +0800
Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
> translated as ENOTTY to user mode.
> For example:
> 	fd = open("/dev/tty", O_RDWR);
> 	ioctl(fd, -1, &argp);
> 
> then the errno should be ENOTTY but not EINVAL.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Acked-by: Alan Cox <alan@linux.intel.com>

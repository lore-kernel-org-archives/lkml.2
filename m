Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2CRCWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 22:22:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37880 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab2CRCWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 22:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <201203180129.38469.rjw@sisk.pl>
References: <201203032122.36745.chunkeey@googlemail.com> <201203170123.10599.rjw@sisk.pl>
 <CA+55aFxiJABjKJz4J6Dwk8Jy4=Vds2P15XTVtX8_j6TDkTwXEg@mail.gmail.com> <201203180129.38469.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Mar 2012 19:21:59 -0700
X-Google-Sender-Auth: zal2Zj3kxT5h2weLYOvL188KgYc
Message-ID: <CA+55aFzrj32d6ROrtSOBn_HgW5m8Nf5ZhF7H6fRfoPwkX=A8-w@mail.gmail.com>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is
 not yet available
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 5:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> The patch below (untested) goes slightly into that direction, although not as
> far as to modify fw_create_instance().  It does, however, split
> _request_firmware() into "prepare", "load" and "cleanup" parts and moves
> the usermodehelper check along with the read-locking of umhelper_sem down
> to the callers, ie. request_firmware() and request_firmware_work_func().

Looks fairly reasonable to me from a quick read-through, and the code
seems to make sense.

                 Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab1EUCgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:36:37 -0400
Received: from ozlabs.org ([203.10.76.45]:58347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681Ab1EUCeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 22:34:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 04/14] vhost: support event index
In-Reply-To: <b227febf884dcf82dee9233e581c6216d0e9daa5.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <b227febf884dcf82dee9233e581c6216d0e9daa5.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 12:01:47 +0930
Message-ID: <87sjs8u6lo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:10:54 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Support the new event index feature. When acked,
> utilize it to reduce the # of interrupts sent to the guest.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, even though it'd normally be in your tree, it's easier for me
to push all together.

Thanks,
Rusty.

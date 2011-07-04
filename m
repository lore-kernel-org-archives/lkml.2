Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1GDOW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:22:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50635 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1GDOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E11C263.3010003@linux.vnet.ibm.com>
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	<4DF71E28.6070009@suse.de>
	<4E0AE36B.9010500@redhat.com>
	<BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
	<4E0D6C08.1040201@redhat.com>
	<4E0D73C4.5090608@suse.de>
	<4E0D86E0.1020406@redhat.com>
	<4E11C263.3010003@linux.vnet.ibm.com>
Date: Mon, 4 Jul 2011 15:22:53 +0100
Message-ID: <CAJSP0QXwo_iMKtBJ1t38mde330HdCYtB_=HVa+3Ge8QPKeGQaQ@mail.gmail.com>
Subject: Re: virtio scsi host draft specification, v3
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Hai Dong,Li" <haidongl@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 2:38 PM, Hai Dong,Li <haidongl@linux.vnet.ibm.com> wrote:
> So if I understand correctly, virtio-scsi looks like an SCSI tranport
> protocol,
> such as iSCSI, FCP and SRP which use tcp/ip, FC and Infiniband RDMA
> respectively as the transfer media while virtio-scsi uses virtio, an virtual
> IO
> channel, as the transfer media?

Correct.

Stefan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2LGXLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:11:17 -0500
Received: from mail.vyatta.com ([76.74.103.46]:34141 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab2LGXLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:11:15 -0500
Date: Fri, 7 Dec 2012 15:11:11 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, rusty@rustcorp.com.au, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, krkumar2@in.ibm.com, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [PATCH net-next v3 1/3] virtio-net: separate fields of
 sending/receiving queue from virtnet_info
Message-ID: <20121207151111.7d2f9150@samsung-9>
In-Reply-To: <1354899897-10423-2-git-send-email-jasowang@redhat.com>
References: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
	<1354899897-10423-2-git-send-email-jasowang@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor style issue reported by checkpatch which can be fixed after merge.
Although sizeof is actually an operator in C, it is considered correct
style to treat it as a function.


WARNING: sizeof hdr->hdr should be sizeof(hdr->hdr)
#293: FILE: drivers/net/virtio_net.c:395:
+	sg_set_buf(rq->sg, &hdr->hdr, sizeof hdr->hdr);

WARNING: sizeof hdr->mhdr should be sizeof(hdr->mhdr)
#552: FILE: drivers/net/virtio_net.c:641:
+		sg_set_buf(sq->sg, &hdr->mhdr, sizeof hdr->mhdr);

WARNING: sizeof hdr->hdr should be sizeof(hdr->hdr)
#555: FILE: drivers/net/virtio_net.c:643:
+		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2JXCxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:53:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48037 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab2JXCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:53:13 -0400
X-AuditID: cbfee611-b7fa86d0000010a9-41-50875817c51d
Date: Wed, 24 Oct 2012 02:53:11 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [Pv-drivers] 3.7-rc2 regression : file copied to CIFS-mounted
 directory corrupted
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?=ED=97=88=EC=A2=85=EB=A7=8C?= <jongman.heo@samsung.com>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121024024610830@jongman.heo
Msgkey: 20121024024610830@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121024024610830@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <22201304.84761351047189110.JavaMail.weblogic@epml04>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zXV3xiPYAg/PnjC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGqjU/2Qt+6VWsnNDN0sB4R7eLkZNDSEBN4ubnQ4wgtoSAicSP
	Se9ZIWwxiQv31rN1MXIB1SxjlPiz6jcbTNG1pbPZIJrnM0r8XhIMYrMIqErc3/uNHcRmE9CR
	6Pi/H2yQsECSxL/G/2C2iECUxKnvR5lAhjILTGOSeL3kIRPEIEWgoYvBhvIKCEqcnPmEBWKZ
	ikTXgSYWiLiqxIvz/6Di4hIX5l5ih7B5JWa0P4WKy0lM+7qGGcKWljg/awMjzDeLvz+GivNL
	HLu9A2gvB1jvk/vBMGN2b/4C9aOAxNQzB6FaNSXaTx6DauWTWLPwLQvMmF2nljPD9N7fMhfs
	FWagV6Z0P2QHGc8M1Lt+lz66r3gFHCUunjvHPoFReRaS1Cwk3bMQupGVLGBkWcUomlqQXFCc
	lJ5qrlecmFtcmpeul5yfu4kRkhQEdzAubbA4xCjAwajEw3vgYluAEGtiWXFl7iFGCQ5mJRHe
	yXeBQrwpiZVVqUX58UWlOanFhxh9gPE3kVlKNDkfmLDySuINjQ2MDQ0tDc1MLU0NcAgrifOW
	e6QECAmkJ5akZqemFqQWwYxj4uCUamA8bBqWn9rZ2Fc+6V95xJ7Tyw6Hn3g0NelhffTS1bfS
	y9/26Tan/wqUUBA8dpEl9Kb831xp5/UVQuo3DqaEFXQvfT1lhoOXKsdTz1jN/3ZPJqSvXWfr
	JdAg/Ghh1/8ZWxL+JRxJ+uXLcfF4d87Oe0rNcg82THEpvpl40UPH48eCl+dyFrk7eVUrsRRn
	JBpqMRcVJwIAQ/R/YjcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/tmbriEe0BBp926Ftc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jFVrfrIX/NKrWDmhm6WB8Y5uFyMnh5CAmsTNz4cYQWwJAROJa0tns0HYYhIX7q1ng6iZzyjx
	e0kwiM0ioCpxf+83dhCbTUBHouP/flYQW1ggSeJf438wW0QgSuLU96NMXYxcHMwC05gkXi95
	yAQxSBFowWKwobwCghInZz5hgVimItF1oIkFIq4q8eL8P6i4uMSFuZfYIWxeiRntT6HichLT
	vq5hhrClJc7P2sAIc/Ti74+h4vwSx27vANrLAdb75H4wzJjdm79A/SggMfXMQahWTYn2k8eg
	Wvkk1ix8ywIzZtep5cwwvfe3zAV7hRnolSndD9lBxjMD9a7fpY/uK14BR4mL586xT2CUm4Uk
	NQtJ9yyEbmQlCxhZVjGKphYkFxQnpaea6xUn5haX5qXrJefnbmIEp6dngjsYlzZYHGIU4GBU
	4uE9cLEtQIg1say4MvcQowQHs5II7+S7QCHelMTKqtSi/Pii0pzU4kOMPsD4m8gsJZqcD0yd
	eSXxhsYGxoaGluYGpoZGFjiElcR5yz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwTgro0+qLblyR
	FGrV9qHg7uUJelxBKlo/rH5FON8K7pnT9e5rxmvBZJutTInzFS4GT+C7P+8M69Ty0FUzT10N
	FJq/d8IBEUHfD0cZp39fsWTTgcUvGBl2FmfO8A2Wu9AtWjI7UZJz4uZHhr8jH0YGavH/XJay
	8fmLNbE8MzZEGk6dPmPuG2V5ISWW4oxEQy3mouJEADTVuVF8AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9O2rQCZ008457

Hi,

------- Original Message -------
Sender : Eric Dumazet
Date : 2012-10-24 04:39 (GMT+09:00)
Title : Re: [Pv-drivers] 3.7-rc2 regression : file copied to CIFS-mounted directory corrupted

On Tue, 2012-10-23 at 15:50 +0200, Eric Dumazet wrote:

> Only the skb head is handled in the code you copy/pasted.
> 
> You need to generalize that to code in lines ~754
> 
> 
> Then, the number of estimated descriptors is bad :
> 
> /* conservatively estimate # of descriptors to use */
> count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) +
> skb_shinfo(skb)->nr_frags + 1;
> 
> 
> Yes, you need a more precise estimation and vmxnet3_map_pkt() should
> eventually split too big frags.

raw patch would be :

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ce9d4f2..0ae1bcc 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -744,28 +744,43 @@ vmxnet3_map_pkt(struct sk_buff *skb, struct vmxnet3_tx_ctx *ctx,

for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+ u32 buf_size;

- tbi = tq->buf_info + tq->tx_ring.next2fill;
- tbi->map_type = VMXNET3_MAP_PAGE;
- tbi->dma_addr = skb_frag_dma_map(&adapter->pdev->dev, frag,
- 0, skb_frag_size(frag),
- DMA_TO_DEVICE);
+ buf_offset = 0;
+ len = skb_frag_size(frag);
+ while (len) {
+ tbi = tq->buf_info + tq->tx_ring.next2fill;
+ if (len < VMXNET3_MAX_TX_BUF_SIZE) {
+ buf_size = len;
+ dw2 |= len;
+ } else {
+ buf_size = VMXNET3_MAX_TX_BUF_SIZE;
+ /* spec says that for TxDesc.len, 0 == 2^14 */
+ }
+ tbi->map_type = VMXNET3_MAP_PAGE;
+ tbi->dma_addr = skb_frag_dma_map(&adapter->pdev->dev, frag,
+ buf_offset, buf_size,
+ DMA_TO_DEVICE);

- tbi->len = skb_frag_size(frag);
+ tbi->len = buf_size;

- gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
- BUG_ON(gdesc->txd.gen == tq->tx_ring.gen);
+ gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
+ BUG_ON(gdesc->txd.gen == tq->tx_ring.gen);

- gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
- gdesc->dword[2] = cpu_to_le32(dw2 | skb_frag_size(frag));
- gdesc->dword[3] = 0;
+ gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
+ gdesc->dword[2] = cpu_to_le32(dw2);
+ gdesc->dword[3] = 0;

- dev_dbg(&adapter->netdev->dev,
- "txd[%u]: 0x%llu %u %u\n",
- tq->tx_ring.next2fill, le64_to_cpu(gdesc->txd.addr),
- le32_to_cpu(gdesc->dword[2]), gdesc->dword[3]);
- vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
- dw2 = tq->tx_ring.gen << VMXNET3_TXD_GEN_SHIFT;
+ dev_dbg(&adapter->netdev->dev,
+ "txd[%u]: 0x%llu %u %u\n",
+ tq->tx_ring.next2fill, le64_to_cpu(gdesc->txd.addr),
+ le32_to_cpu(gdesc->dword[2]), gdesc->dword[3]);
+ vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
+ dw2 = tq->tx_ring.gen << VMXNET3_TXD_GEN_SHIFT;
+
+ len -= buf_size;
+ buf_offset += buf_size;
+ }
}

ctx->eop_txd = gdesc;
@@ -886,6 +901,18 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
}
}

+static int txd_estimate(const struct sk_buff *skb)
+{
+ int count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) + 1;
+ int i;
+
+ for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+ const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+
+ count += VMXNET3_TXD_NEEDED(skb_frag_size(frag));
+ }
+ return count;
+}

/*
  * Transmits a pkt thru a given tq
@@ -914,9 +941,7 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
union Vmxnet3_GenericDesc tempTxDesc;
#endif

- /* conservatively estimate # of descriptors to use */
- count = VMXNET3_TXD_NEEDED(skb_headlen(skb)) +
- skb_shinfo(skb)->nr_frags + 1;
+ count = txd_estimate(skb);

ctx.ipv4 = (vlan_get_protocol(skb) == cpu_to_be16(ETH_P_IP));

------- Original Message End -------

Hi, Eric, 
your raw patch seemed to fix the issue. But after ~200 runs, copied file has been corrupted again.

 # cmp -l /home/local.bin /mnt/cifs/new.bin | awk '{printf "%08X %02X %02X\n", $1, strtonum(0$2), strtonum(0$3)}' > diff.log

I compared the difference between source and copied file. Size of file is 45872732 bytes (= 0x2BBF65C).
Among them, 4096 (0x1000) bytes are different, from 0x2B96001 to 0x2B97000. Instead of original data, 0x00 was copied in those area.

patch applied on top of 2d1f4c8e ("Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux").

Regards,
Jongman Heo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

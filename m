Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2J2FpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:45:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64081 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2J2FpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:45:09 -0400
X-AuditID: cbfee60c-b7fb06d00000355f-e0-508e17e1dbe6
Date: Mon, 29 Oct 2012 05:45:04 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: Re: [Pv-drivers] 3.7-rc2 regression : file copied to
 CIFS-mounted directory corrupted
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20121029053525306@jongman.heo
Msgkey: 20121029053525306@jongman.heo
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
X-ParentMTR: 20121024024610830@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <14353539.198251351489501891.JavaMail.weblogic@epml12>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zXd2H4n0BBn/WKVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MizP3sxRMM694+2YdcwPjHdMuRk4OIQE1iZufDzGC2BICJhK/
	VxxggbDFJC7cW8/WxcgFVLOMUeLv3m1wRVd+N7BCJOYzSryde5QVJMEioCoxe3MnWDebgI5E
	x//9YHFhgTSJxx8esIHYIgJREqe+H2UCaWYWOM8osfjAeUaIMxQlri1dDFbEKyAocXLmE6gz
	VCTWTjoJ1MABFFeVWHnNAiIsLnFh7iV2CJtXYkb7U6hyOYlpX9cwQ9jSEudnbWCE+Wbx98dQ
	cX6JY7d3gI0E6X1yPxhmzO7NX9ggbAGJqWcOQrVqSrSfPAbVqi1xfcNMRpgxu04tZ4bpvb9l
	LhOIzQz0yZTuh+wg45mBetfv0kf3FK+Ak8TGD8tZJzAqz0KSmoWkexZCN7KSBYwsqxhFUwuS
	C4qT0lON9IoTc4tL89L1kvNzNzFCkgLPDsY5DRaHGAU4GJV4eB987Q0QYk0sK67MPcQowcGs
	JMK7lBsoxJuSWFmVWpQfX1Sak1p8iNEHGH0TmaVEk/OBCSuvJN7Q2MDY0NDS0MzU0tQAh7CS
	OG+dR0qAkEB6YklqdmpqQWoRzDgmDk6pBkYX3v2Xz1+YqaxQUjUt5bOOFOeXvfFbJpX6rQv6
	KnJM4qhPvY/M8xPHL263OtucL5vq023zadcS43+FxyoCs56vqyp5+PPnWYazz6LDNZZO+dPD
	vUU9k2n3pYoX01S3/Kp+sKW1Nvy52EHGJYICja8v2pZc+vtZMH3idaGSL3KaDcaR+TuPq1Uo
	sRRnJBpqMRcVJwIATXWr4zcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/tmboPxPsCDJZMULO4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GRdn7mcpmGZe8fbNOuYGxjumXYycHEICahI3Px9iBLElBEwkrvxuYIWwxSQu3FvP1sXIBVQz
	n1Hi7dyjYAkWAVWJ2Zs7WUBsNgEdiY7/+8HiwgJpEo8/PGADsUUEoiROfT/KBNLMLHCeUWLx
	gfOMENsUJa4tXQxWxCsgKHFy5hMWiG0qEmsnnQRq4ACKq0qsvGYBERaXuDD3EjuEzSsxo/0p
	VLmcxLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zvARoL0PrkfDDNm9+YvbBC2gMTUMwehWjUl
	2k8eg2rVlri+YSYjzJhdp5Yzw/Te3zKXCcRmBvpkSvdDdpDxzEC963fpo3uKV8BJYuOH5awT
	GOVmIUnNQtI9C6EbWckCRpZVjKKpBckFxUnpqUZ6xYm5xaV56XrJ+bmbGMHp6RnPDsY5DRaH
	GAU4GJV4eB987Q0QYk0sK67MPcQowcGsJMK7lBsoxJuSWFmVWpQfX1Sak1p8iNEHGH0TmaVE
	k/OBqTOvJN7Q2MDY0NDS3MDU0MgCh7CSOG+dR0qAkEB6YklqdmpqQWoRzDgmDk6pBsbkW11f
	RVL2/3OcWPmdISgg7sqa8vjFx73v3l2rybh3ATuPod0suSf/+552tIezHRYukmOUeGVWl7d2
	/oNJG8MkzFUWh2ofKLMxjmBc6auVdtz1HuPfu4uXXE/X/JHyw/xO2feGjMCXnYpMsQtuZXzP
	+5W/MSQoo7lsA9eWE4eWtx3Y1zxt1WolluKMREMt5qLiRABbZ1hBfAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9T5jSo9002742



------- Original Message -------
Sender : Jongman Heo<jongman.heo@samsung.com>
Date : 2012-10-24 11:53 (GMT+09:00)
Title : Re: Re: [Pv-drivers] 3.7-rc2 regression : file copied to CIFS-mounted directory corrupted

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

------- Original Message End -------

Hi, 

As I said in the previous post, with 2d1f4c8e + Eric's patch, I got the issue mentioned above ; sometimes 4096 bytes are being copied by all zeros. Not easily reproducible, but always happened before running ~500 runs.

But with 3.7-rc3 + the patch, I haven't encountered the issue so far, until ~2000 runs.
Maybe, the root cause is fixed by Eric's patch, and the remaining subtle bug, corrupting 4096 bytes, might be fixed by other commit, between 3.7-rc2 and -rc3.

Thanks,
Jongman Heo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

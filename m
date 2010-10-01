Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0JASyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:54:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53317 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0JASyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ib13O8iZCMC37kqtg6+UWxVeGxCuX/HsOwnLcaTYHWLMpObnbkQfFXYzqkvqNCHG65
         JcRICiBuTvtCoqbJcrmSXQYkwDWIgo8dE9jj9XuIc4Qsd7FtNYHWNFCgw++/5XlXFwqM
         wpur7VCcSw78FKI/DjtTvLJdtSP1wjTjGrXbA=
MIME-Version: 1.0
In-Reply-To: <1285946861.21547.24.camel@edumazet-laptop>
References: <20100930062419.GD86786@beaver.vrungel.ru>
	<1285828432.5211.812.camel@edumazet-laptop>
	<20100930122321.GA1575@beaver.vrungel.ru>
	<1285850669.2615.426.camel@edumazet-laptop>
	<20100930173732.GB4094@beaver.vrungel.ru>
	<1285869782.2615.920.camel@edumazet-laptop>
	<20100930181556.GC4094@beaver.vrungel.ru>
	<1285872765.2615.1008.camel@edumazet-laptop>
	<20101001101650.GD4094@beaver.vrungel.ru>
	<1285937966.2641.117.camel@edumazet-laptop>
	<20101001141858.GE4094@beaver.vrungel.ru>
	<1285946861.21547.24.camel@edumazet-laptop>
Date: Fri, 1 Oct 2010 11:54:08 -0700
X-Google-Sender-Auth: opZJ-_2Pf4Y69mPwt4q1N9XvJq0
Message-ID: <AANLkTi=8_Xi=yV0XxKG9uBnDh0p6ygr1s-8qT9-sVk58@mail.gmail.com>
Subject: Re: Packet time delays on multi-core systems
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Vlasov <renton@renton.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Emil Tantilov <emil.s.tantilov@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 08:27, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 01 octobre 2010 à 18:18 +0400, Alexey Vlasov a écrit :
>
>> NIC statistics:
>>      rx_packets: 2973717440
>>      tx_packets: 3032670910
>>      rx_bytes: 1892633650741
>>      tx_bytes: 2536130682695
>>      rx_broadcast: 118773199
>>      tx_broadcast: 68013
>>      rx_multicast: 95257
>>      tx_multicast: 0
>>      rx_errors: 0
>>      tx_errors: 0
>>      tx_dropped: 0
>>      multicast: 95257
>>      collisions: 0
>>      rx_length_errors: 0
>>      rx_over_errors: 0
>>      rx_crc_errors: 0
>>      rx_frame_errors: 0
>>      rx_no_buffer_count: 7939
>>      rx_queue_drop_packet_count: 1324025520
>>      rx_missed_errors: 146631
>>      tx_aborted_errors: 0
>>      tx_carrier_errors: 0
>>      tx_fifo_errors: 0
>>      tx_heartbeat_errors: 0
>>      tx_window_errors: 0
>>      tx_abort_late_coll: 0
>>      tx_deferred_ok: 0
>>      tx_single_coll_ok: 0
>>      tx_multi_coll_ok: 0
>>      tx_timeout_count: 0
>>      tx_restart_queue: 50715
>>      rx_long_length_errors: 0
>>      rx_short_length_errors: 0
>>      rx_align_errors: 0
>>      tx_tcp_seg_good: 344724062
>>      tx_tcp_seg_failed: 0
>>      rx_flow_control_xon: 0
>>      rx_flow_control_xoff: 0
>>      tx_flow_control_xon: 0
>>      tx_flow_control_xoff: 0
>>      rx_long_byte_count: 1892633650741
>>      rx_csum_offload_good: 2973697420
>>      rx_csum_offload_errors: 6235
>>      tx_dma_out_of_sync: 0
>>      alloc_rx_buff_failed: 0
>>      tx_smbus: 9327
>>      rx_smbus: 118531661
>>      dropped_smbus: 0
>>      tx_queue_0_packets: 797617475
>>      tx_queue_0_bytes: 630191908685
>>      tx_queue_1_packets: 719681297
>>      tx_queue_1_bytes: 625907304846
>>      tx_queue_2_packets: 718841556
>>      tx_queue_2_bytes: 620522418855
>>      tx_queue_3_packets: 796521255
>>      tx_queue_3_bytes: 646196024585
>>      rx_queue_0_packets: 788885797
>>      rx_queue_0_bytes: 458936338699
>>      rx_queue_0_drops: 0
>>      rx_queue_1_packets: 701354604
>>      rx_queue_1_bytes: 457490536453
>>      rx_queue_1_drops: 0
>>      rx_queue_2_packets: 791887663
>>      rx_queue_2_bytes: 534425333616
>>      rx_queue_2_drops: 0
>>      rx_queue_3_packets: 691579028
>>      rx_queue_3_bytes: 429887244557
>>      rx_queue_3_drops: 0
>> 11.111.80: R 1983626201:1983626201(0) win 0
>> > >
>
> OK
>
> IGB stats are wrong... for rx_queue_drop_packet_count field at least
>
> Here is a patch against 2.6.32.23, to get the idea...
>
> Dont trust it unless you patch your kernel ;)
>
> Thanks
>
> Note: current linux-2.6 tree doesnt have this bug.
>
> [PATCH] igb: rx_fifo_errors counter fix
>
> Alexey Vlasov reported insane rx_queue_drop_packet_count
> (rx_fifo_errors) values.
>
> IGB drivers is doing an accumulation for 82575, instead using a zero
> value for rqdpc_total.
>
> Reported-by: Alexey Vlasov <renton@renton.name>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  linux-2.6.32.23/net/igb/igb_main.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>

Thanks Eric!  I have added the patch to my queue.

-- 
Cheers,
Jeff

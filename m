Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2D3Vuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:50:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40430 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2D3Vua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:50:30 -0400
Message-ID: <4F9F091F.1060600@gmail.com>
Date: Mon, 30 Apr 2012 14:50:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH NEXT]staging: rtl8192u Fix typos.
References: <1335796896-4486-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1204302207050.3688@swampdragon.chaosbits.net> <4F9EFAB5.1070103@gmail.com> <alpine.LNX.2.00.1204302304070.3688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204302304070.3688@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 02:05 PM, Jesper Juhl wrote:
> On Mon, 30 Apr 2012, Justin P. Mattock wrote:
>
>> On 04/30/2012 01:41 PM, Jesper Juhl wrote:
>>> On Mon, 30 Apr 2012, Justin P. Mattock wrote:
>>>
>>>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>>>
>>>>    Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>
>>>> ---
>>>>
>>>> The below patch fixes some typos that I found while going through
>>>> staging/rtl8192u
>>>>
>>>
>>> I think it needs a little more work - see below.
>>>
>>>
>>>>    drivers/staging/rtl8192u/r8180_93cx6.c     |    2 +-
>>>>    drivers/staging/rtl8192u/r8180_93cx6.h     |    2 +-
>>>>    drivers/staging/rtl8192u/r8192U.h          |    6 +-
>>>>    drivers/staging/rtl8192u/r8192U_core.c     |   56
>>>> ++++++++++++++--------------
>>>>    drivers/staging/rtl8192u/r8192U_dm.c       |   50
>>>> ++++++++++++------------
>>>>    drivers/staging/rtl8192u/r8192U_hw.h       |    2 +-
>>>>    drivers/staging/rtl8192u/r8192U_wx.c       |    8 ++--
>>>>    drivers/staging/rtl8192u/r8192U_wx.h       |    2 +-
>>>>    drivers/staging/rtl8192u/r819xU_HTType.h   |    2 +-
>>>>    drivers/staging/rtl8192u/r819xU_cmdpkt.c   |    8 ++--
>>>>    drivers/staging/rtl8192u/r819xU_firmware.c |    4 +-
>>>>    drivers/staging/rtl8192u/r819xU_phy.c      |   16 ++++----
>>>>    drivers/staging/rtl8192u/r819xU_phyreg.h   |    2 +-
>>>>    13 files changed, 80 insertions(+), 80 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c
>>>> b/drivers/staging/rtl8192u/r8180_93cx6.c
>>>> index 8878cfe..0e8ff75 100644
>>>> --- a/drivers/staging/rtl8192u/r8180_93cx6.c
>>>> +++ b/drivers/staging/rtl8192u/r8180_93cx6.c
>>>> @@ -14,7 +14,7 @@
>>>>
>>>>       Parts of this driver are based on the Intel Pro Wireless 2100 GPL
>>>> driver.
>>>>
>>>> -   We want to tanks the Authors of those projects and the Ndiswrapper
>>>> +   We want to thanks the Authors of those projects and the Ndiswrapper
>>>>       project Authors.
>>>
>>> I believe this would be better like this:
>>>
>>>         We want to thank the authors of those projects and the Ndiswrapper
>>>         project authors.
>>>
>>>
>>>>    */
>>>>
>>>> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.h
>>>> b/drivers/staging/rtl8192u/r8180_93cx6.h
>>>> index fb3ac97..3527d32 100644
>>>> --- a/drivers/staging/rtl8192u/r8180_93cx6.h
>>>> +++ b/drivers/staging/rtl8192u/r8180_93cx6.h
>>>> @@ -7,7 +7,7 @@
>>>>    	Parts of this driver are based on the rtl8180 driver skeleton from
>>>> Patric Schenke&   Andres Salomon
>>>>    	Parts of this driver are based on the Intel Pro Wireless 2100 GPL
>>>> driver
>>>>
>>>> -	We want to tanks the Authors of such projects and the Ndiswrapper
>>>> project Authors.
>>>> +	We want to thanks the Authors of such projects and the Ndiswrapper
>>>> project Authors.
>>>
>>> Same comment as above "We want to thank .." rather than "We want to
>>> thanks ..". And "authors" rather than "Authors".
>>>
>>>
>>>>    */
>>>>
>>>>    /*This files contains card eeprom (93c46 or 93c56) programming
>>>> routines*/
>>>> diff --git a/drivers/staging/rtl8192u/r8192U.h
>>>> b/drivers/staging/rtl8192u/r8192U.h
>>>> index 43d459d..adeb724 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U.h
>>>> +++ b/drivers/staging/rtl8192u/r8192U.h
>>>> @@ -11,7 +11,7 @@
>>>>
>>>>       Parts of this driver are based on the Intel Pro Wireless 2100 GPL
>>>> driver
>>>>
>>>> -   We want to tanks the Authors of those projects and the Ndiswrapper
>>>> +   We want to thanks the Authors of those projects and the Ndiswrapper
>>>>       project Authors.
>>>
>>> Same comment as above.
>>>
>>>
>>>>    */
>>>>
>>>> @@ -98,7 +98,7 @@ do { if(rt_global_debug_component&   component) \
>>>>    #define COMP_INIT				BIT2		// during
>>>> driver initialization / halt / reset.
>>>>
>>>>
>>>> -#define COMP_RECV				BIT3		// Reveive
>>>> part data path.
>>>> +#define COMP_RECV				BIT3		// Revive part
>>>> data path.
>>>
>>> Are you sure that "Receive data path." is not what was intended here?
>>>
>>>
>>>>    #define COMP_SEND				BIT4		// Send part
>>>> path.
>>>>    #define COMP_IO					BIT5		// I/O
>>>> Related. Added by Annie, 2006-03-02.
>>>>    #define COMP_POWER				BIT6		//
>>>> 802.11 Power Save mode or System/Device Power state related.
>>>> @@ -322,7 +322,7 @@ typedef struct _tx_fwinfo_819x_usb {
>>>>            u8		TxSubCarrier:2;         // This is used for
>>>> legacy OFDM rate only.
>>>>            u8		STBC:2;
>>>>            u8		AllowAggregation:1;
>>>> -        u8		RtsHT:1;                //Interpre RtsRate field as
>>>> high throughput data rate
>>>> +        u8		RtsHT:1;                //Interprete RtsRate field as
>>>> high throughput data rate
>>>
>>> I believe this should be "Interpret RtsRate field as high throughput data
>>> rate".
>>>
>>>
>>>>            u8		RtsShort:1;             //Short PLCP for CCK,
>>>> or short GI for 11n MCS
>>>>            u8		RtsBandwidth:1;         // This is used for HT
>>>> MCS rate only.
>>>>            u8		RtsSubcarrier:2;        // This is used for
>>>> legacy OFDM rate only.
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_core.c
>>>> b/drivers/staging/rtl8192u/r8192U_core.c
>>>> index 9c00865..be86045 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_core.c
>>>> +++ b/drivers/staging/rtl8192u/r8192U_core.c
>>>> @@ -203,7 +203,7 @@ static void rtl819x_set_channel_map(u8 channel_plan,
>>>> struct r8192_priv* priv)
>>>>    		{
>>>>    			Dot11d_Init(ieee);
>>>>    			ieee->bGlobalDomain = false;
>>>> -			//acturally 8225&   8256 rf chip only support B,G,24N
>>>> mode
>>>> +			//actually 8225&   8256 rf chip only support B,G,24N
>>>> mode
>>>
>>> "chip" is singular, but here there are two of them (8225&   8256) so I
>>> believe you should use the plural "chips".
>>>
>>>
>>>>    			if ((priv->rf_chip == RF_8225) || (priv->rf_chip ==
>>>> RF_8256))
>>>>    			{
>>>>    				min_chan = 1;
>>>> @@ -1103,7 +1103,7 @@ inline u16 rtl8192_rate2rate(short rate)
>>>>    }
>>>>
>>>>
>>>> -/* The protype of rx_isr has changed since one verion of Linux Kernel */
>>>> +/* The prototype of rx_isr has changed since one version of Linux Kernel
>>>> */
>>>
>>> Can't argue with the correction of the spelling of "prototype" but, while
>>> you are at it, why not fix the entire sentence? "has changed since one
>>> version of the Linux kernel" - what does that really mean?  If you don't
>>> know either then I'm fine with just leaving it to the spelling fix :-)
>>>
>>>
>>>>    static void rtl8192_rx_isr(struct urb *urb)
>>>>    {
>>>>    	struct sk_buff *skb = (struct sk_buff *) urb->context;
>>>> @@ -1476,7 +1476,7 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
>>>>    	if(tcb_desc->queue_index != TXCMD_QUEUE) {
>>>>    		if(tx_urb->status == 0) {
>>>>    			dev->trans_start = jiffies;
>>>> -			// As act as station mode, destion shall be  unicast
>>>> address.
>>>> +			// As act as station mode, destination shall be
>>>> unicast address.
>>>
>>> Perhaps "// Act as station mode, destination shall ..." ?
>>>
>>>
>>>>    			//priv->ieee80211->stats.tx_bytes+=(skb->len -
>>>> priv->ieee80211->tx_headroom);
>>>>    			//priv->ieee80211->stats.tx_packets++;
>>>>    			priv->stats.txoktotal++;
>>>> @@ -1522,13 +1522,13 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
>>>>    			else if
>>>> ((skb_queue_len(&priv->ieee80211->skb_drv_aggQ[queue_index])!= 0)&&\
>>>>    				(!(priv->ieee80211->queue_stop))) {
>>>>    				// Tx Driver Aggregation process
>>>> -				/* The driver will aggregation the packets
>>>> according to the following stets
>>>> +				/* The driver will aggregation the packets
>>>> according to the following stats
>>>>    				 * 1. check whether there's tx irq available,
>>>> for it's a completion return
>>>>    				 *    function, it should contain enough tx
>>>> irq;
>>>> -				 * 2. check pakcet type;
>>>> +				 * 2. check packet type;
>>>>    				 * 3. initialize sendlist, check whether the
>>>> to-be send packet no greater than 1
>>>> -				 * 4. aggregation the packets, and fill
>>>> firmware info and tx desc to it, etc.
>>>> -				 * 5. check whehter the packet could be sent,
>>>> otherwise just insert to wait head
>>>> +				 * 4. aggregates the packets, and fill
>>>> firmware info and tx desc to it, etc.
>>>
>>> "... and fill firmware info and tx desc into it ..." perhaps?
>>>
>>>> +				 * 5. check whether the packet could be sent,
>>>> otherwise just insert to wait head
>>>
>>> "... insert into wait head" perhaps?
>>>
>>>
>>>>    				* */
>>>>    				skb =
>>>> skb_dequeue(&priv->ieee80211->skb_drv_aggQ[queue_index]);
>>>>    				if(!check_nic_enough_desc(dev, queue_index)) {
>>>> @@ -2447,7 +2447,7 @@ static int rtl8192_qos_handle_probe_response(struct
>>>> r8192_priv *priv,
>>>>    	return 0;
>>>>    }
>>>>
>>>> -/* handle manage frame frame beacon and probe response */
>>>> +/* handle and manage frame from beacon and probe response */
>>>>    static int rtl8192_handle_beacon(struct net_device * dev,
>>>>    			      struct ieee80211_beacon * beacon,
>>>>    			      struct ieee80211_network * network)
>>>> @@ -2625,7 +2625,7 @@ bool GetHalfNmodeSupportByAPs819xUsb(struct
>>>> net_device* dev)
>>>>    void rtl8192_refresh_supportrate(struct r8192_priv* priv)
>>>>    {
>>>>    	struct ieee80211_device* ieee = priv->ieee80211;
>>>> -	//we donot consider set support rate for ABG mode, only HT MCS rate is
>>>> set here.
>>>> +	//we do not consider set support rate for ABG mode, only HT MCS rate
>>>> is set here.
>>>>    	if (ieee->mode == WIRELESS_MODE_N_24G || ieee->mode ==
>>>> WIRELESS_MODE_N_5G)
>>>>    	{
>>>>    		memcpy(ieee->Regdot11HTOperationalRateSet,
>>>> ieee->RegHTSuppRateSet, 16);
>>>> @@ -2780,10 +2780,10 @@ static void rtl8192_init_priv_variable(struct
>>>> net_device* dev)
>>>>    	priv->TransmitConfig =
>>>>    	//	TCR_DurProcMode |	//for RTL8185B, duration setting by HW
>>>>    	//?	TCR_DISReqQsize |
>>>> -		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|  // Max DMA Burst Size per
>>>> Tx DMA Burst, 7: reservied.
>>>> +		(TCR_MXDMA_2048<<TCR_MXDMA_OFFSET)|  // Max DMA Burst Size per
>>>> Tx DMA Burst, 7: reserved.
>>>>    		(priv->ShortRetryLimit<<TCR_SRL_OFFSET)|	// Short retry
>>>> limit
>>>>    		(priv->LongRetryLimit<<TCR_LRL_OFFSET) |	// Long retry
>>>> limit
>>>> -		(false ? TCR_SAT: 0);	// FALSE: HW provies PLCP length and
>>>> LENGEXT, TURE: SW proiveds them
>>>> +		(false ? TCR_SAT: 0);	// FALSE: HW provides PLCP length and
>>>> LENGEXT, TURE: SW provides them
>>>
>>> I believe "TURE" wants to be changed to "TRUE".
>>>
>>>
>>>>    #ifdef TO_DO_LIST
>>>>    	if(Adapter->bInHctTest)
>>>>    		pHalData->ReceiveConfig	=	pHalData->CSMethod |
>>>> @@ -3437,7 +3437,7 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
>>>>    		{ // User disable RF via registry.
>>>>    			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD,
>>>> ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
>>>>    			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
>>>> -			// Those action will be discard in MgntActSet_RF_State
>>>> because off the same state
>>>> +			// Those action will be discard in MgntActSet_RF_State
>>>> because of the same state
>>>
>>> Shouldn't this be "Those actions" (plural) rather than "Those action" ?
>>>
>>>
>>>>    			for(eRFPath = 0; eRFPath<pHalData->NumTotalRFPath;
>>>> eRFPath++)
>>>>    				PHY_SetRFReg(Adapter,
>>>> (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
>>>>    		}
>>>> @@ -3458,7 +3458,7 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
>>>>    		if(pHalData->eRFPowerState == eRfOff)
>>>>    		{
>>>>    			MgntActSet_RF_State(Adapter, eRfOff,
>>>> pMgntInfo->RfOffReason);
>>>> -			// Those action will be discard in MgntActSet_RF_State
>>>> because off the same state
>>>> +			// Those action will be discard in MgntActSet_RF_State
>>>> because of the same state
>>>
>>> Same comment as above.
>>>
>>>
>>>>    			for(eRFPath = 0; eRFPath<pHalData->NumTotalRFPath;
>>>> eRFPath++)
>>>>    				PHY_SetRFReg(Adapter,
>>>> (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
>>>>    		}
>>>> @@ -3586,7 +3586,7 @@ TxCheckStuck(struct net_device *dev)
>>>>    	//unsigned long flags;
>>>>
>>>>    	//
>>>> -	// Decide Stuch threshold according to current power save mode
>>>> +	// Decide such threshold according to current power save mode
>>>>    	//
>>>>
>>>>    //     RT_TRACE(COMP_RESET, " ==>   TxCheckStuck()\n");
>>>> @@ -3745,7 +3745,7 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
>>>>
>>>>    		// Driver should not check RX stuck in IBSS mode because it is
>>>> required to
>>>>    		// set Check BSSID in order to send beacon, however, if check
>>>> BSSID is
>>>> -		// set, STA cannot hear any packet a all. Emily, 2008.04.12
>>>> +		// set, STA cannot hear any packet at all. Emily, 2008.04.12
>>>>    		RxResetType = RxCheckStuck(dev);
>>>>    	}
>>>>    	if(TxResetType==RESET_TYPE_NORMAL || RxResetType==RESET_TYPE_NORMAL)
>>>> @@ -3962,7 +3962,7 @@ RESET_START:
>>>>    		up(&priv->wx_sem);
>>>>    		RT_TRACE(COMP_RESET,"%s():<==========down process is
>>>> finished\n",__FUNCTION__);
>>>>    	//rtl8192_irq_disable(dev);
>>>> -		RT_TRACE(COMP_RESET,"%s():===========>start to up the
>>>> driver\n",__FUNCTION__);
>>>> +		RT_TRACE(COMP_RESET,"%s():===========>start up the
>>>> driver\n",__FUNCTION__);
>>>>    		reset_status = _rtl8192_up(dev);
>>>>
>>>>    		RT_TRACE(COMP_RESET,"%s():<===========up process is
>>>> finished\n",__FUNCTION__);
>>>> @@ -4155,7 +4155,7 @@ extern	void
>>>> rtl819x_watchdog_wqcallback(struct work_struct *work)
>>>>    void watch_dog_timer_callback(unsigned long data)
>>>>    {
>>>>    	struct r8192_priv *priv = ieee80211_priv((struct net_device *) data);
>>>> -	//printk("===============>watch_dog  timer\n");
>>>> +	//printk("===============>watch_dog timer\n");
>>>>    	queue_delayed_work(priv->priv_wq,&priv->watch_dog_wq, 0);
>>>>    	mod_timer(&priv->watch_dog_timer, jiffies +
>>>> MSECS(IEEE80211_WATCH_DOG_TIME));
>>>>    }
>>>> @@ -4170,7 +4170,7 @@ int _rtl8192_up(struct net_device *dev)
>>>>    	init_status = rtl8192_adapter_start(dev);
>>>>    	if(!init_status)
>>>>    	{
>>>> -		RT_TRACE(COMP_ERR,"ERR!!! %s(): initialization is failed!\n",
>>>> __FUNCTION__);
>>>> +		RT_TRACE(COMP_ERR,"ERR!!! %s(): initialization failed!\n",
>>>> __FUNCTION__);
>>>>    		priv->up=priv->ieee80211->ieee_up = 0;
>>>>    		return -EAGAIN;
>>>>    	}
>>>> @@ -4256,7 +4256,7 @@ int rtl8192_down(struct net_device *dev)
>>>>    		skb_queue_purge(&priv->ieee80211->skb_drv_aggQ [i]);
>>>>    	}
>>>>
>>>> -	//as cancel_delayed_work will del work->timer, so if work is not
>>>> definedas struct delayed_work, it will corrupt
>>>> +	//as cancel_delayed_work will del work->timer, so if work is not
>>>> defined as struct delayed_work, it will corrupt
>>>>    //	flush_scheduled_work();
>>>>    	rtl8192_cancel_deferred_work(priv);
>>>>    	deinit_hal_dm(dev);
>>>> @@ -4516,7 +4516,7 @@ u8 HwRateToMRate90(bool bIsHT, u8 rate)
>>>>
>>>>    /**
>>>>     * Function:     UpdateRxPktTimeStamp
>>>> - * Overview:     Recored down the TSF time stamp when receiving a packet
>>>> + * Overview:     Record down the TSF time stamp when receiving a packet
>>>
>>> Why not just "Record the TSF time stamp ..." ?
>>>
>>>
>>>>     *
>>>>     * Input:
>>>>     *       PADAPTER        Adapter
>>>> @@ -4556,9 +4556,9 @@ long rtl819x_translate_todbm(u8
>>>> signal_strength_index	)// 0-100 index.
>>>>    }
>>>>
>>>>
>>>> -/* 2008/01/22 MH We can not delcare RSSI/EVM total value of sliding
>>>> window to
>>>> +/* 2008/01/22 MH We can not declare RSSI/EVM total value of sliding
>>>> window to
>>>>        be a local static. Otherwise, it may increase when we return from
>>>> S3/S4. The
>>>> -    value will be kept in memory or disk. We must delcare the value in
>>>> adapter
>>>> +    value will be kept in memory or disk. We must declare the value in
>>>> adapter
>>>
>>> Shouldn't it be "declare the value in the ...".
>>>
>>> And shouldn't it be "adaptor" rather than "adapter"? Since an "adaptor" is
>>> a device and "adapter" is a person who's able to adapt.
>>>
>>>
>>>>        and it will be reinitialized when return from S3/S4. */
>>>>    void rtl8192_process_phyinfo(struct r8192_priv * priv,u8* buffer, struct
>>>> ieee80211_rx_stats * pprevious_stats, struct ieee80211_rx_stats *
>>>> pcurrent_stats)
>>>>    {
>>>> @@ -5091,7 +5091,7 @@ static void rtl8192_query_rxphystatus(
>>>>    			tmp_rxevm =	pofdm_buf->rxevm_X[i];
>>>>    			rx_evmX = (char)(tmp_rxevm);
>>>>
>>>> -			// Do not use shift operation like "rx_evmX>>= 1"
>>>> because the compilor of free build environment
>>>> +			// Do not use shift operation like "rx_evmX>>= 1"
>>>> because the compiler of free build environment
>>>>    			// fill most significant bit to "zero" when doing
>>>> shifting operation which may change a negative
>>>
>>> "fill most significant bit to "zero" when doing..." sounds a bit broken to
>>> me (but I could be wrong). I would have corrected this to "will set the
>>> most significant bit to "zero" when doing ..."
>>> Better or??
>>>
>>>
>>>>    			// value to positive one, then the dbm value (which is
>>>> supposed to be negative)  is not correct anymore.
>>>>    			rx_evmX /= 2;	//dbm
>>>> @@ -5171,7 +5171,7 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff
>>>> *skb,
>>>>    	type = WLAN_FC_GET_TYPE(fc);
>>>>    	praddr = hdr->addr1;
>>>>
>>>> -	/* Check if the received packet is acceptabe. */
>>>> +	/* Check if the received packet is acceptable. */
>>>>    	bpacket_match_bssid = ((IEEE80211_FTYPE_CTL != type)&&
>>>>    							(eqMacAddr(priv->ieee80211->current_network.bssid,
>>>> (fc&   IEEE80211_FCTL_TODS)? hdr->addr1 : (fc&   IEEE80211_FCTL_FROMDS )?
>>>> hdr->addr2 : hdr->addr3))
>>>>    								&&
>>>> (!pstats->bHwError)&&   (!pstats->bCRC)&&   (!pstats->bICV));
>>>> @@ -5211,7 +5211,7 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff
>>>> *skb,
>>>>
>>>>    /**
>>>>    * Function:	UpdateReceivedRateHistogramStatistics
>>>> -* Overview:	Recored down the received data rate
>>>> +* Overview:	Record down the received data rate
>>>
>>> What about just "Record the received data rate".
>>>
>>>
>>>>    *
>>>>    * Input:
>>>>    * 	struct net_device *dev
>>>> @@ -5401,7 +5401,7 @@ void query_rxdesc_status(struct sk_buff *skb, struct
>>>> ieee80211_rx_stats *stats,
>>>>    	}
>>>>
>>>>    #ifdef USB_RX_AGGREGATION_SUPPORT
>>>> -	/* for the rx aggregated sub frame, the redundant space truelly
>>>> contained in the packet */
>>>> +	/* for the rx aggregated sub frame, the redundant space truly
>>>> contained in the packet */
>>>>    	if(bIsRxAggrSubframe) {
>>>>    		skb_pull(skb, 8);
>>>>    	}
>>>> @@ -5480,7 +5480,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
>>>>    			PacketShiftBytes =
>>>> GetRxPacketShiftBytes819xUsb(&stats, false);
>>>>    		}
>>>>    #endif
>>>> -		/* Process the MPDU recevied */
>>>> +		/* Process the MPDU received */
>>>>    		skb_trim(skb, skb->len - 4/*sCrcLng*/);
>>>>
>>>>    		rx_pkt_len = skb->len;
>>>> @@ -5538,7 +5538,7 @@ void rtl8192_rx_nomal(struct sk_buff* skb)
>>>>    				if(PacketLength>   agg_skb->len) {
>>>>    					break;
>>>>    				}
>>>> -				/* Process the MPDU recevied */
>>>> +				/* Process the MPDU received */
>>>>    				skb = dev_alloc_skb(PacketLength);
>>>>    				memcpy(skb_put(skb,PacketLength),agg_skb->data,
>>>> PacketLength);
>>>>    				skb_trim(skb, skb->len - 4/*sCrcLng*/);
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_dm.c
>>>> b/drivers/staging/rtl8192u/r8192U_dm.c
>>>> index 2dde9fa..3f79e61 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_dm.c
>>>> +++ b/drivers/staging/rtl8192u/r8192U_dm.c
>>>> @@ -38,7 +38,7 @@ static u32 edca_setting_UL[HT_IOT_PEER_MAX] =
>>>>    /*------------------------Define global
>>>> variable-----------------------------*/
>>>>    // Debug variable ?
>>>>    dig_t	dm_digtable;
>>>> -// Store current shoftware write register content for MAC PHY.
>>>> +// Store current software write register content for MAC PHY.
>>>>    u8		dm_shadow[16][256] = {{0}};
>>>>    // For Dynamic Rx Path Selection by Signal Strength
>>>>    DRxPathSel	DM_RxPathSelTable;
>>>> @@ -119,7 +119,7 @@ static	void	dm_pd_th(struct net_device *dev);
>>>>    static	void	dm_cs_ratio(struct net_device *dev);
>>>>
>>>>    static	void dm_init_ctstoself(struct net_device *dev);
>>>> -// DM -->   EDCA turboe mode control
>>>> +// DM -->   EDCA turbo mode control
>>>>    static	void	dm_check_edca_turbo(struct net_device *dev);
>>>>
>>>>    // DM -->   HW RF control
>>>> @@ -348,7 +348,7 @@ extern void init_rate_adaptive(struct net_device *
>>>> dev)
>>>>     *
>>>>     * Revised History:
>>>>     *	When		Who		Remark
>>>> - *	05/26/08	amy 	Create version 0 proting from windows code.
>>>> + *	05/26/08	amy 	Create version 0 porting from windows code.
>>>>     *
>>>>     *---------------------------------------------------------------------------*/
>>>>    static void dm_check_rate_adaptive(struct net_device * dev)
>>>> @@ -543,7 +543,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
>>>>    	0x5a400169,	// 3, +3db
>>>>    	0x50800142,	// 4, +2db
>>>>    	0x47c0011f,	// 5, +1db
>>>> -	0x40000100,	// 6, +0db ===>   default, upper for higher temprature,
>>>> lower for low temprature
>>>> +	0x40000100,	// 6, +0db ===>   default, upper for higher
>>>> temperature, lower for low temperature
>>>>    	0x390000e4,	// 7, -1db
>>>>    	0x32c000cb,	// 8, -2db
>>>>    	0x2d4000b5,	// 9, -3db
>>>> @@ -678,7 +678,7 @@ static void dm_TXPowerTrackingCallback_TSSI(struct
>>>> net_device * dev)
>>>>    		{
>>>>    			write_nic_byte(dev, 0x1ba, 0);
>>>>    			viviflag = FALSE;
>>>> -			RT_TRACE(COMP_POWER_TRACKING, "we filted this
>>>> data\n");
>>>> +			RT_TRACE(COMP_POWER_TRACKING, "we filtered the
>>>> data\n");
>>>>    			for(k = 0;k<   5; k++)
>>>>    				tmp_report[k] = 0;
>>>>    			break;
>>>> @@ -864,14 +864,14 @@ static void
>>>> dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
>>>>    	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n",
>>>> tmpRegA);
>>>>    	if(tmpRegA<   3 || tmpRegA>   13)
>>>>    		return;
>>>> -	if(tmpRegA>= 12)	// if over 12, TP will be bad when high
>>>> temprature
>>>> +	if(tmpRegA>= 12)	// if over 12, TP will be bad when high
>>>> temperature
>>>>    		tmpRegA = 12;
>>>>    	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
>>>>    	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value
>>>> by Bryant's suggestion
>>>>    	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value
>>>> by Bryant's suggestion
>>>>
>>>> -	//Get current RF-A temprature index
>>>> -	if(priv->ThermalMeter[0]>= (u8)tmpRegA)	//lower temprature
>>>> +	//Get current RF-A temperature index
>>>> +	if(priv->ThermalMeter[0]>= (u8)tmpRegA)	//lower temperature
>>>>    	{
>>>>    		tmpOFDMindex = tmpCCK20Mindex =
>>>> 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
>>>>    		tmpCCK40Mindex = tmpCCK20Mindex - 6;
>>>> @@ -885,7 +885,7 @@ static void
>>>> dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
>>>>    	else
>>>>    	{
>>>>    		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
>>>> -		if(tmpval>= 6)
>>>> // higher temprature
>>>> +		if(tmpval>= 6)
>>>> // higher temperature
>>>>    			tmpOFDMindex = tmpCCK20Mindex = 0;		// max
>>>> to +6dB
>>>>    		else
>>>>    			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
>>>> @@ -1457,9 +1457,9 @@ static void
>>>> dm_InitializeTXPowerTracking_ThermalMeter(struct net_device *dev)
>>>>    {
>>>>    	struct r8192_priv *priv = ieee80211_priv(dev);
>>>>
>>>> -	// Tx Power tracking by Theremal Meter require Firmware R/W 3-wire.
>>>> This mechanism
>>>> +	// Tx Power tracking by Thermal Meter require Firmware R/W 3-wire.
>>>> This mechanism
>>>
>>> Shouldn't this be "requires" rather than "require" ?
>>> No argument about the Theremal-->Thermal change :)
>>>
>>>
>>>>    	// can be enabled only when Firmware R/W 3-wire is enabled. Otherwise,
>>>> frequent r/w
>>>> -	// 3-wire by driver cause RF goes into wrong state.
>>>> +	// 3-wire by driver causes RF to go into a wrong state.
>>>>    	if(priv->ieee80211->FwRWRF)
>>>>    		priv->btxpower_tracking = TRUE;
>>>>    	else
>>>> @@ -1520,7 +1520,7 @@ static void
>>>> dm_CheckTXPowerTracking_ThermalMeter(struct net_device *dev)
>>>>
>>>>    	if(!TM_Trigger)
>>>>    	{
>>>> -		//Attention!! You have to wirte all 12bits data to RF, or it
>>>> may cause RF to crash
>>>> +		//Attention!! You have to write all 12bits data to RF, or it
>>>> may cause RF to crash
>>>
>>> How about "... all 12 bits of data ..." ?
>>>
>>>
>>>>    		//actually write reg0x02 bit1=0, then bit1=1.
>>>>    		//DbgPrint("Trigger ThermalMeter, write RF reg0x2 = 0x4d to
>>>> 0x4f\n");
>>>>    		rtl8192_phy_SetRFReg(dev, RF90_PATH_A, 0x02, bMask12Bits,
>>>> 0x4d);
>>>> @@ -1744,7 +1744,7 @@ extern void
>>>> dm_restore_dynamic_mechanism_state(struct net_device *dev)
>>>>    			write_nic_dword(dev, RATR0, ratr_value);
>>>>    			write_nic_byte(dev, UFWP, 1);
>>>>    	}
>>>> -	//Resore TX Power Tracking Index
>>>> +	//Restore TX Power Tracking Index
>>>>    	if(priv->btxpower_trackingInit&&   priv->btxpower_tracking){
>>>>    		dm_txpower_reset_recovery(dev);
>>>>    	}
>>>> @@ -2031,7 +2031,7 @@ static void dm_dig_init(struct net_device *dev)
>>>>    	dm_digtable.dbg_mode = DM_DBG_OFF;	//off=by real rssi value,
>>>> on=by DM_DigTable.Rssi_val for new dig
>>>>    	dm_digtable.dig_algorithm_switch = 0;
>>>>
>>>> -	/* 2007/10/04 MH Define init gain threshol. */
>>>> +	/* 2007/10/04 MH Define init gain threshold. */
>>>>    	dm_digtable.dig_state		= DM_STA_DIG_MAX;
>>>>    	dm_digtable.dig_highpwr_state	= DM_STA_DIG_MAX;
>>>>    	dm_digtable.initialgain_lowerbound_state = false;
>>>> @@ -2097,7 +2097,7 @@ static void dm_ctrl_initgain_byrssi_by_driverrssi(
>>>>    		return;
>>>>
>>>>    	//DbgPrint("Dig by Sw Rssi \n");
>>>> -	if(dm_digtable.dig_algorithm_switch)	// if swithed algorithm, we
>>>> have to disable FW Dig.
>>>> +	if(dm_digtable.dig_algorithm_switch)	// if switched algorithm, we
>>>> have to disable FW Dig.
>>>>    		fw_dig = 0;
>>>>    	if(fw_dig<= 3)	// execute several times to make sure the FW Dig is
>>>> disabled
>>>>    	{// FW DIG Off
>>>> @@ -2160,7 +2160,7 @@ static void
>>>> dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
>>>>    	/*DbgPrint("DIG Check\n\r RSSI=%d LOW=%d HIGH=%d STATE=%d",
>>>>    	pHalData->UndecoratedSmoothedPWDB, DM_DigTable.RssiLowThresh,
>>>>    	DM_DigTable.RssiHighThresh, DM_DigTable.Dig_State);*/
>>>> -	/* 1. When RSSI decrease, We have to judge if it is smaller than a
>>>> treshold
>>>> +	/* 1. When RSSI decrease, We have to judge if it is smaller than a
>>>> threshold
>>>>    		  and then execute below step. */
>>>>    	if ((priv->undecorated_smoothed_pwdb<= dm_digtable.rssi_low_thresh))
>>>>    	{
>>>> @@ -2220,7 +2220,7 @@ static void
>>>> dm_ctrl_initgain_byrssi_by_fwfalse_alarm(
>>>>
>>>>    	}
>>>>
>>>> -	/* 2. When RSSI increase, We have to judge if it is larger than a
>>>> treshold
>>>> +	/* 2. When RSSI increase, We have to judge if it is larger than a
>>>> threshold
>>>>    		  and then execute below step.  */
>>>>    	if ((priv->undecorated_smoothed_pwdb>= dm_digtable.rssi_high_thresh) )
>>>>    	{
>>>> @@ -2329,7 +2329,7 @@ static void dm_ctrl_initgain_byrssi_highpwr(
>>>>    	}
>>>>
>>>>    	/* 3. When RSSI>75% or<70%, it is a high power issue. We have to judge
>>>> if
>>>> -		  it is larger than a treshold and then execute below step.
>>>> */
>>>> +		  it is larger than a threshold and then execute below step.
>>>> */
>>>
>>> "the step below" rather than "below step"? (also seen above).
>>>
>>>
>>>>    	// 2008/02/05 MH SD3-Jerry Modify PD_TH for high power issue.
>>>>    	if (priv->undecorated_smoothed_pwdb>=
>>>> dm_digtable.rssi_high_power_highthresh)
>>>>    	{
>>>> @@ -2841,8 +2841,8 @@ static void dm_check_rfctrl_gpio(struct net_device *
>>>> dev)
>>>>    {
>>>>    	//struct r8192_priv *priv = ieee80211_priv(dev);
>>>>
>>>> -	// Walk around for DTM test, we will not enable HW - radio on/off
>>>> because r/w
>>>> -	// page 1 register before Lextra bus is enabled cause system fails
>>>> when resuming
>>>> +	// Work around for DTM test, we will not enable HW - radio on/off
>>>> because r/w
>>>> +	// page 1 register before extra bus is enabled causing system fails
>>>> when resuming
>>>
>>> "system failure" or "system failures" rather than "system fails" perhaps?
>>>
>>>
>>>
>>>>    	// from S4. 20080218, Emily
>>>>
>>>>    	// Stop to execute workitem to prevent S3/S4 bug.
>>>> @@ -3377,13 +3377,13 @@ extern void dm_fsync_timer_callback(unsigned long
>>>> data)
>>>>    		{
>>>>
>>>>    			u32 DiffNum = priv->rateCountDiffRecord -
>>>> rate_count_diff;
>>>> -			// Contiune count
>>>> +			// Continue count
>>>>    			if(DiffNum>=
>>>> priv->ieee80211->fsync_seconddiff_ratethreshold)
>>>>    				priv->ContiuneDiffCount++;
>>>>    			else
>>>>    				priv->ContiuneDiffCount = 0;
>>>>
>>>> -			// Contiune count over
>>>> +			// Continue count over
>>>>    			if(priv->ContiuneDiffCount>=2)
>>>>    			{
>>>>    				bSwitchFromCountDiff = true;
>>>> @@ -3392,7 +3392,7 @@ extern void dm_fsync_timer_callback(unsigned long
>>>> data)
>>>>    		}
>>>>    		else
>>>>    		{
>>>> -			// Stop contiune count
>>>> +			// Stop continue count
>>>
>>> "Stop counting" ?
>>>
>>>
>>>>    			priv->ContiuneDiffCount = 0;
>>>>    		}
>>>>
>>>> @@ -3523,7 +3523,7 @@ static void dm_StartSWFsync(struct net_device *dev)
>>>>    	RT_TRACE(COMP_HALDM,"%s\n", __FUNCTION__);
>>>>    	// Initial rate record to zero, start to record.
>>>>    	priv->rate_record = 0;
>>>> -	// Initial contiune diff count to zero, start to record.
>>>> +	// Initial continue diff count to zero, start to record.
>>>
>>> How about "// Initialize continue diff count to zero, start to record."
>>>
>>>>    	priv->ContiuneDiffCount = 0;
>>>
>>> "Continue" is misspelled in this variable name as well - that ought to
>>> also be fixed IMHO.
>>>
>>>
>>>>    	priv->rateCountDiffRecord = 0;
>>>>    	priv->bswitch_fsync  = false;
>>>> @@ -3875,7 +3875,7 @@ static void dm_send_rssi_tofw(struct net_device
>>>> *dev)
>>>>
>>>>    	// If we test chariot, we should stop the TX command ?
>>>>    	// Because 92E will always silent reset when we send tx command. We
>>>> use register
>>>> -	// 0x1e0(byte) to botify driver.
>>>> +	// 0x1e0(byte) to notify driver.
>>>>    	write_nic_byte(dev, DRIVER_RSSI, (u8)priv->undecorated_smoothed_pwdb);
>>>>    	return;
>>>>    	tx_cmd.Op		= TXCMD_SET_RX_RSSI;
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_hw.h
>>>> b/drivers/staging/rtl8192u/r8192U_hw.h
>>>> index e89aaf7..b0ee4dd 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_hw.h
>>>> +++ b/drivers/staging/rtl8192u/r8192U_hw.h
>>>> @@ -10,7 +10,7 @@
>>>>    	Parts of this driver are based on the Intel Pro Wireless
>>>>    	2100 GPL driver.
>>>>
>>>> -	We want to tanks the Authors of those projects
>>>> +	We want to thanks the Authors of those projects
>>>
>>> "We want to thank the authors ..."
>>>
>>>
>>>>    	and the Ndiswrapper project Authors.
>>>>    */
>>>>
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_wx.c
>>>> b/drivers/staging/rtl8192u/r8192U_wx.c
>>>> index 981de9b..2ce0fc8 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_wx.c
>>>> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
>>>> @@ -13,7 +13,7 @@
>>>>
>>>>       Parts of this driver are based on the Intel Pro Wireless 2100 GPL
>>>> driver.
>>>>
>>>> -   We want to tanks the Authors of those projects and the Ndiswrapper
>>>> +   We want to thanks the Authors of those projects and the Ndiswrapper
>>>>       project Authors.
>>>
>>> Same comment as above.
>>>
>>>
>>>>    */
>>>>
>>>> @@ -256,7 +256,7 @@ static int r8192_wx_get_ap_status(struct net_device
>>>> *dev,
>>>>    	//count the length of input ssid
>>>>    	for(name_len=0 ; ((char*)wrqu->data.pointer)[name_len]!='\0' ;
>>>> name_len++);
>>>>
>>>> -	//search for the correspoding info which is received
>>>> +	//search for the corresponding info which is received
>>>>    	list_for_each_entry(target,&ieee->network_list, list) {
>>>>    		if ( (target->ssid_len == name_len)&&
>>>>    		(strncmp(target->ssid, (char*)wrqu->data.pointer,
>>>> name_len)==0)){
>>>> @@ -419,7 +419,7 @@ static int rtl8180_wx_get_range(struct net_device
>>>> *dev,
>>>>    	range->max_qual.updated = 7; /* Updated all three */
>>>>
>>>>    	range->avg_qual.qual = 92; /*>   8% missed beacons is 'bad' */
>>>> -	/* TODO: Find real 'good' to 'bad' threshol value for RSSI */
>>>> +	/* TODO: Find real 'good' to 'bad' threshold value for RSSI */
>>>>    	range->avg_qual.level = 20 + -98;
>>>>    	range->avg_qual.noise = 0;
>>>>    	range->avg_qual.updated = 7; /* Updated all three */
>>>> @@ -1047,7 +1047,7 @@ static iw_handler r8192_wx_handlers[] =
>>>>    #else
>>>>    	 NULL,
>>>>    #endif
>>>> -	dummy,                     /* SIOCGIWAPLIST -- depricated */
>>>> +	dummy,                     /* SIOCGIWAPLIST -- deprecated */
>>>>    	r8192_wx_set_scan,        /* SIOCSIWSCAN */
>>>>    	r8192_wx_get_scan,        /* SIOCGIWSCAN */
>>>>    	r8192_wx_set_essid,       /* SIOCSIWESSID */
>>>> diff --git a/drivers/staging/rtl8192u/r8192U_wx.h
>>>> b/drivers/staging/rtl8192u/r8192U_wx.h
>>>> index f4cf280..1388664 100644
>>>> --- a/drivers/staging/rtl8192u/r8192U_wx.h
>>>> +++ b/drivers/staging/rtl8192u/r8192U_wx.h
>>>> @@ -7,7 +7,7 @@
>>>>    	Parts of this driver are based on the rtl8180 driver skeleton from
>>>> Patric Schenke&   Andres Salomon
>>>>    	Parts of this driver are based on the Intel Pro Wireless 2100 GPL
>>>> driver
>>>>
>>>> -	We want to tanks the Authors of such projects and the Ndiswrapper
>>>> project Authors.
>>>> +	We want to thanks the Authors of such projects and the Ndiswrapper
>>>> project Authors.
>>>
>>> Same comment here as the previous comment above.
>>>
>>>
>>>>    */
>>>>
>>>>    /* this file (will) contains wireless extension handlers*/
>>>> diff --git a/drivers/staging/rtl8192u/r819xU_HTType.h
>>>> b/drivers/staging/rtl8192u/r819xU_HTType.h
>>>> index 2ac4216..e07f8b1 100644
>>>> --- a/drivers/staging/rtl8192u/r819xU_HTType.h
>>>> +++ b/drivers/staging/rtl8192u/r819xU_HTType.h
>>>> @@ -211,7 +211,7 @@ typedef struct _RT_HIGH_THROUGHPUT{
>>>>    	u8				bEnableHT;
>>>>    	u8				bCurrentHTSupport;
>>>>
>>>> -	u8				bRegBW40MHz;
>>>> // Tx 40MHz channel capablity
>>>> +	u8				bRegBW40MHz;
>>>> // Tx 40MHz channel capability
>>>>    	u8				bCurBW40MHz;
>>>> // Tx 40MHz channel capability
>>>>
>>>>    	u8				bRegShortGI40MHz;
>>>> // Tx Short GI for 40Mhz
>>>> diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
>>>> b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
>>>> index 9348f42..ec1eeb7 100644
>>>> --- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
>>>> +++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
>>>> @@ -157,7 +157,7 @@ SendTxCommandPacket(
>>>>    		seg_ptr = skb_put(skb, buffer_len);
>>>>    		/*
>>>>    		 * Transform from little endian to big endian
>>>> -		 * and pending  zero
>>>> +		 * and pending zero
>>>>    		 */
>>>>    		memcpy(seg_ptr,codevirtualaddress,buffer_len);
>>>>    		tcb_desc->txbuf_size= (u16)buffer_len;
>>>> @@ -718,15 +718,15 @@ cmpk_message_handle_rx(
>>>>    	/* 2. Read virtual address from RFD. */
>>>>    	pcmd_buff = pstats->virtual_address;
>>>>
>>>> -	/* 3. Read command pakcet element id and length. */
>>>> +	/* 3. Read command packet element id and length. */
>>>>    	element_id = pcmd_buff[0];
>>>>    	/*RT_TRACE(COMP_SEND, DebugLevel,
>>>>    			("\n\r[CMPK]-->element ID=%d Len=%d", element_id,
>>>> total_length));*/
>>>>
>>>> -	/* 4. Check every received command packet conent according to
>>>> different
>>>> +	/* 4. Check every received command packet content according to
>>>> different
>>>>    	      element type. Because FW may aggregate RX command packet to
>>>> minimize
>>>>    	      transmit time between DRV and FW.*/
>>>> -	// Add a counter to prevent to locked in the loop too long
>>>> +	// Add a counter to prevent the lock in the loop to be to long
>>>
>>> Perhaps "... to prevent the lock in the loop to be held too long" would be
>>> better?
>>>
>
> Baah, that was a bad sentence I came up with there.
> This would be better I think:
>
> "... to prevent the lock in the loop from being held for too long".
>
>


alright! whatever works best..
I sent out what you had mentioned, also I will send out a new patch for 
ContiuneDiffCount but it wont be until later today so I can compile test 
this before sending out..

Justin P. Mattock

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0CTAVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:21:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38999 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751978Ab0CTAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:21:14 -0400
Date: Sat, 20 Mar 2010 01:20:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mto.h Coding style fixes
Message-ID: <20100320002058.GJ1477@ucw.cz>
References: <1269031405-28978-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031405-28978-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-19 21:43:25, Lars Lindley wrote:
> I fixed all problems reported by checkpatch.pl except for a couple of
> long lines. I also removed version comments and removed "commented away"
> code.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ack.

> ---
>  drivers/staging/winbond/mto.h |  179 +++++++++++++++++++----------------------
>  1 files changed, 82 insertions(+), 97 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
> index fb4781d..a0f659c 100644
> --- a/drivers/staging/winbond/mto.h
> +++ b/drivers/staging/winbond/mto.h
> @@ -1,13 +1,10 @@
> -//==================================================================
> -// MTO.H
> -//
> -// Revision history
> -//=================================
> -//          20030110    UN20 Pete Chao
> -//                      Initial Release
> -//
> -// Copyright (c) 2003 Winbond Electronics Corp. All rights reserved.
> -//==================================================================
> +/*
> + * ==================================================================
> + * MTO.H
> + *
> + * Copyright (c) 2003 Winbond Electronics Corp. All rights reserved.
> + * ==================================================================
> + */
>  #ifndef __MTO_H__
>  #define __MTO_H__
>  
> @@ -15,115 +12,104 @@
>  
>  struct wbsoft_priv;
>  
> -// LA20040210_DTO kevin
> -//#define MTO_PREAMBLE_LONG               0
> -//#define MTO_PREAMBLE_SHORT              1
>  #define MTO_PREAMBLE_LONG               WLAN_PREAMBLE_TYPE_LONG
>  #define MTO_PREAMBLE_SHORT              WLAN_PREAMBLE_TYPE_SHORT
>  
> -//============================================================================
> -// struct _MTOParameters --
> -//
> -//   Defines the parameters used in the MAC Throughput Optimization algorithm
> -//============================================================================
> +/* Defines the parameters used in the MAC Throughput Optimization algorithm */
>  struct wb35_mto_params {
> -	//---------        wkchen added      -------------
> -	u32		TxFlowCount;	//to judge what kind the tx flow(sparse or busy) is
> -	//------------------------------------------------
> +	u32	TxFlowCount; /* to judge what kind the tx flow(sparse or busy) is */
>  
> -	//--------- DTO threshold parameters -------------
> -	u16		DTO_PeriodicCheckCycle;
> -	u16		DTO_RssiThForAntDiv;
> +	/* --------- DTO threshold parameters ------------- */
> +	u16	DTO_PeriodicCheckCycle;
> +	u16	DTO_RssiThForAntDiv;
>  
> -	u16		DTO_TxCountThForCalcNewRate;
> -	u16		DTO_TxRateIncTh;
> +	u16	DTO_TxCountThForCalcNewRate;
> +	u16	DTO_TxRateIncTh;
>  
> -	u16		DTO_TxRateDecTh;
> -	u16		DTO_TxRateEqTh;
> +	u16	DTO_TxRateDecTh;
> +	u16	DTO_TxRateEqTh;
>  
> -	u16		DTO_TxRateBackOff;
> -	u16		DTO_TxRetryRateReduce;
> +	u16	DTO_TxRateBackOff;
> +	u16	DTO_TxRetryRateReduce;
>  
> -	u16		DTO_TxPowerIndex;	//0 ~ 31
> -	u16		reserved_1;
> -	//------------------------------------------------
> +	u16	DTO_TxPowerIndex;		/* 0 ~ 31 */
> +	u16	reserved_1;
> +	/* ------------------------------------------------ */
>  
> -	u8      PowerChangeEnable;
> -	u8      AntDiversityEnable;
> -	u8      CCA_Mode;
> -	u8      CCA_Mode_Setup;
> -	u8      Preamble_Type;
> -	u8      PreambleChangeEnable;
> +	u8	PowerChangeEnable;
> +	u8	AntDiversityEnable;
> +	u8	CCA_Mode;
> +	u8	CCA_Mode_Setup;
> +	u8	Preamble_Type;
> +	u8	PreambleChangeEnable;
>  
> -	u8      DataRateLevel;
> -	u8      DataRateChangeEnable;
> -	u8      FragThresholdLevel;
> -	u8      FragThresholdChangeEnable;
> +	u8	DataRateLevel;
> +	u8	DataRateChangeEnable;
> +	u8	FragThresholdLevel;
> +	u8	FragThresholdChangeEnable;
>  
> -	u16     RTSThreshold;
> -	u16     RTSThreshold_Setup;
> +	u16	RTSThreshold;
> +	u16	RTSThreshold_Setup;
>  
> -	u32     AvgIdleSlot;
> -	u32     Pr_Interf;
> -	u32     AvgGapBtwnInterf;
> +	u32	AvgIdleSlot;
> +	u32	Pr_Interf;
> +	u32	AvgGapBtwnInterf;
>  
> -	u8	   RTSChangeEnable;
> -	u8      Ant_sel;
> -	u8      aging_timeout;
> -	u8	   reserved_2;
> +	u8	RTSChangeEnable;
> +	u8	Ant_sel;
> +	u8	aging_timeout;
> +	u8	reserved_2;
>  
> -	u32     Cnt_Ant[2];
> -	u32     SQ_Ant[2];
> +	u32	Cnt_Ant[2];
> +	u32	SQ_Ant[2];
>  
> -// 20040510 remove from globe vairable
> -	u8		FallbackRateLevel;
> -	u8		OfdmRateLevel;
> +	u8	FallbackRateLevel;
> +	u8	OfdmRateLevel;
>  
> -	u8		RatePolicy;
> -	u8		reserved_3[3];
> -
> -	// For RSSI turning
> -	s32		RSSI_high;
> -	s32		RSSI_low;
> +	u8	RatePolicy;
> +	u8	reserved_3[3];
>  
> +	/* For RSSI turning */
> +	s32	RSSI_high;
> +	s32	RSSI_low;
>  };
>  
>  
> -#define MTO_DATA()                  (adapter->sMtoPara)
> -#define MTO_HAL()                   (&adapter->sHwData)
> -#define MTO_SET_PREAMBLE_TYPE(x)    // 20040511 Turbo mark LM_PREAMBLE_TYPE(&pcore_data->lm_data) = (x)
> -#define MTO_ENABLE					(adapter->sLocalPara.TxRateMode == RATE_AUTO)
> -#define MTO_TXPOWER_FROM_EEPROM		(adapter->sHwData.PowerIndexFromEEPROM)
> -#define LOCAL_ANTENNA_NO()			(adapter->sLocalPara.bAntennaNo)
> -#define LOCAL_IS_CONNECTED()		(adapter->sLocalPara.wConnectedSTAindex != 0)
> -#define MTO_INITTXRATE_MODE			(adapter->sHwData.SoftwareSet&0x2)	//bit 1
> +#define MTO_DATA()		(adapter->sMtoPara)
> +#define MTO_HAL()		(&adapter->sHwData)
> +#define MTO_SET_PREAMBLE_TYPE(x) /* Turbo mark LM_PREAMBLE_TYPE(&pcore_data->lm_data) = (x) */
> +#define MTO_ENABLE		(adapter->sLocalPara.TxRateMode == RATE_AUTO)
> +#define MTO_TXPOWER_FROM_EEPROM	(adapter->sHwData.PowerIndexFromEEPROM)
> +#define LOCAL_ANTENNA_NO()	(adapter->sLocalPara.bAntennaNo)
> +#define LOCAL_IS_CONNECTED()	(adapter->sLocalPara.wConnectedSTAindex != 0)
> +#define MTO_INITTXRATE_MODE	(adapter->sHwData.SoftwareSet&0x2) /* bit 1 */
>  
> -#define MTO_POWER_CHANGE_ENABLE()   MTO_DATA().PowerChangeEnable
> -#define MTO_CCA_MODE()              MTO_DATA().CCA_Mode
> -#define MTO_CCA_MODE_SETUP()        MTO_DATA().CCA_Mode_Setup
> -#define MTO_PREAMBLE_TYPE()         MTO_DATA().Preamble_Type
> -#define MTO_PREAMBLE_CHANGE_ENABLE()         MTO_DATA().PreambleChangeEnable
> +#define MTO_POWER_CHANGE_ENABLE()	MTO_DATA().PowerChangeEnable
> +#define MTO_CCA_MODE()			MTO_DATA().CCA_Mode
> +#define MTO_CCA_MODE_SETUP()		MTO_DATA().CCA_Mode_Setup
> +#define MTO_PREAMBLE_TYPE()		MTO_DATA().Preamble_Type
> +#define MTO_PREAMBLE_CHANGE_ENABLE()	MTO_DATA().PreambleChangeEnable
>  
> -#define MTO_RATE_LEVEL()            MTO_DATA().DataRateLevel
> +#define MTO_RATE_LEVEL()		MTO_DATA().DataRateLevel
>  #define MTO_OFDM_RATE_LEVEL()		MTO_DATA().OfdmRateLevel
> -#define MTO_RATE_CHANGE_ENABLE()    MTO_DATA().DataRateChangeEnable
> -#define MTO_FRAG_TH_LEVEL()         MTO_DATA().FragThresholdLevel
> -#define MTO_FRAG_CHANGE_ENABLE()    MTO_DATA().FragThresholdChangeEnable
> -#define MTO_RTS_THRESHOLD()         MTO_DATA().RTSThreshold
> -#define MTO_RTS_CHANGE_ENABLE()     MTO_DATA().RTSChangeEnable
> -#define MTO_RTS_THRESHOLD_SETUP()   MTO_DATA().RTSThreshold_Setup
> +#define MTO_RATE_CHANGE_ENABLE()	MTO_DATA().DataRateChangeEnable
> +#define MTO_FRAG_TH_LEVEL()		MTO_DATA().FragThresholdLevel
> +#define MTO_FRAG_CHANGE_ENABLE()	MTO_DATA().FragThresholdChangeEnable
> +#define MTO_RTS_THRESHOLD()		MTO_DATA().RTSThreshold
> +#define MTO_RTS_CHANGE_ENABLE()		MTO_DATA().RTSChangeEnable
> +#define MTO_RTS_THRESHOLD_SETUP()	MTO_DATA().RTSThreshold_Setup
>  
> -#define MTO_AVG_IDLE_SLOT()         MTO_DATA().AvgIdleSlot
> -#define MTO_PR_INTERF()             MTO_DATA().Pr_Interf
> -#define MTO_AVG_GAP_BTWN_INTERF()   MTO_DATA().AvgGapBtwnInterf
> +#define MTO_AVG_IDLE_SLOT()		MTO_DATA().AvgIdleSlot
> +#define MTO_PR_INTERF()			MTO_DATA().Pr_Interf
> +#define MTO_AVG_GAP_BTWN_INTERF()	MTO_DATA().AvgGapBtwnInterf
>  
> -#define MTO_CNT_ANT(x)              MTO_DATA().Cnt_Ant[(x)]
> -#define MTO_SQ_ANT(x)               MTO_DATA().SQ_Ant[(x)]
> -#define MTO_AGING_TIMEOUT()         MTO_DATA().aging_timeout
> +#define MTO_CNT_ANT(x)			MTO_DATA().Cnt_Ant[(x)]
> +#define MTO_SQ_ANT(x)			MTO_DATA().SQ_Ant[(x)]
> +#define MTO_AGING_TIMEOUT()		MTO_DATA().aging_timeout
>  
> +#define MTO_TXFLOWCOUNT()		MTO_DATA().TxFlowCount
>  
> -#define MTO_TXFLOWCOUNT()			MTO_DATA().TxFlowCount
> -//--------- DTO threshold parameters -------------
> +/* --------- DTO threshold parameters ------------- */
>  #define	MTOPARA_PERIODIC_CHECK_CYCLE()		MTO_DATA().DTO_PeriodicCheckCycle
>  #define	MTOPARA_RSSI_TH_FOR_ANTDIV()		MTO_DATA().DTO_RssiThForAntDiv
>  #define	MTOPARA_TXCOUNT_TH_FOR_CALC_RATE()	MTO_DATA().DTO_TxCountThForCalcNewRate
> @@ -133,13 +119,13 @@ struct wb35_mto_params {
>  #define	MTOPARA_TXRATE_BACKOFF()		MTO_DATA().DTO_TxRateBackOff
>  #define	MTOPARA_TXRETRYRATE_REDUCE()		MTO_DATA().DTO_TxRetryRateReduce
>  #define MTOPARA_TXPOWER_INDEX()			MTO_DATA().DTO_TxPowerIndex
> -//------------------------------------------------
> +/* ------------------------------------------------ */
>  
>  
> -extern u16  MTO_Frag_Th_Tbl[];
> +extern u16 MTO_Frag_Th_Tbl[];
>  
> -#define MTO_DATA_RATE()          MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
> -#define MTO_FRAG_TH()            MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
> +#define MTO_DATA_RATE()			MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
> +#define MTO_FRAG_TH()			MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
>  
>  extern void MTO_Init(struct wbsoft_priv *);
>  extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
> @@ -148,6 +134,5 @@ extern u8 MTO_GetTxRate(struct wbsoft_priv *adapter, u32 fpdu_len);
>  extern u8 MTO_GetTxFallbackRate(struct wbsoft_priv *adapter);
>  extern void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
>  
> -#endif //__MTO_H__
> -
> +#endif /* __MTO_H__ */
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

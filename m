Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2HGOZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:25:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43631 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2HGOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:25:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: acme@ghostprotocols.net, davem@davemloft.net, bhutchings@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1344348020-4966-1-git-send-email-ahiliation@yahoo.co.in>
Date: Tue, 07 Aug 2012 07:25:07 -0700
In-Reply-To: <1344348020-4966-1-git-send-email-ahiliation@yahoo.co.in>
	(Jeffrin Jose's message of "Tue, 7 Aug 2012 19:30:20 +0530")
Message-ID: <874noeeq4c.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/iIvXASuuxsVwp+eqb3X5Pz7SLCBYXu1s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0208]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeffrin Jose <ahiliation@yahoo.co.in>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] net:appletalk:ddp:fixed coding style issue again relating to
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrin Jose <ahiliation@yahoo.co.in> writes:

>  	case TIOCINQ: {
>  			/*
>  			 * These two are safe on a single CPU system as only
>  			 * user tasks fiddle here
>  			 */
> -			struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> -			long amount = 0;
> +		struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> +		long amount = 0;
>  
> -			if (skb)
> -				amount = skb->len - sizeof(struct ddpehdr);
> +		if (skb)
> +			amount = skb->len - sizeof(struct ddpehdr);
>  			rc = put_user(amount, (int __user *)argp);
>  			break;
>  		}

Is putting "rc = put_user(amount, (int __user *)argp);" on the same
indentation level as "amount = skb->len - sizeof(struct ddpehdr);"
really what you want to do?

Eric


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1ECSwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:52:55 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:56901 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1ECSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:52:53 -0400
X-WSS-ID: 0LKMV43-0B-0FO-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <4DC04EF0.4020909@sandia.gov>
Date: Tue, 3 May 2011 12:52:32 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: "James Bottomley" <James.Bottomley@suse.de>
cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
References: <4DC0330F.6050906@sandia.gov>
 <1304442019.10982.7.camel@mulgrave.site> <4DC03B0A.50209@sandia.gov>
 <1304444251.10982.9.camel@mulgrave.site> <4DC0415F.5020509@sandia.gov>
In-Reply-To: <4DC0415F.5020509@sandia.gov>
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.5.3.183921
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS
 0, BODY_SIZE_200_299 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0,
 DATE_TZ_NA 0, SMALL_BODY 0, WEBMAIL_SOURCE 0, WEBMAIL_XOIP 0,
 WEBMAIL_X_IP_HDR 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT
 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_XOIP 0,
 __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0,
 __RATWARE_X_MAILER_CS_B 0, __SANE_MSGID 0, __TO_MALFORMED_2 0,
 __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110503185244; ID=1; SEV=2.3.1;
 DFV=B2011050318; IFV=NA; AIF=B2011050318; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230352E34444330344546432E303038433A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2011050318_5.03.0010
X-WSS-ID: 61DE91712TS2763132-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

FWIW, I noticed that commit 99f3c722e23 in scsi-rc-fixes-2.6
might want a Cc: stable@kernel.org, since the commit it's
fixing, 86cbfb5607d4, had one.

I'm not sure how that all works, but I thought I'd mention it
just in case.

-- Jim




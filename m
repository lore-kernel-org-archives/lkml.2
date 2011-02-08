Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1BHELs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:11:48 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24025 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1BHELr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:11:47 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Bhupesh SHARMA'" <bhupesh.sharma@st.com>,
        "'Wolfgang Grandegger'" <wg@grandegger.com>
Cc: <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1296818921.git.segoon@openwall.com><a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com><20110204124233.GB334@e-circ.dyndns.org><20110204.130649.112613896.davem@davemloft.net><5009516791F146C49C73FAC57C437313@hacdom.okisemi.com><4D4FDEF9.2030305@grandegger.com> <E2BAACFF191C4175854E6B2EB9135BE5@hacdom.okisemi.com> <D5ECB3C7A6F99444980976A8C6D896384DEE2BE1A7@EAPEX1MAIL1.st.com>
Subject: RE: About bittiming calculation result
Date: Tue, 8 Feb 2011 13:11:44 +0900
Message-ID: <B50CC78E66FD4D1FA262EDC22C21C0D0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE2BE1A7@EAPEX1MAIL1.st.com>
Thread-Index: AcvGvnY9D/1fOfusQtWXGnU3k7EAIQAar9MgAAWxPiAAAXb6gA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Bhupesh,

On Tuesday, February 08, 2011 12:30 PM, Bhupesh SHARMA wrote:
> AFAIK pch uses the Bosch C_CAN core internally.
> As per Bosch C_CAN user manual tseg1= prop_seg + phase_seg1 
> So, ideally tseg1_min should be 2. My version of Bosch C_CAN 
> driver Uses the value 2.

Thank you for your suggestions.
I will submit the patch.

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


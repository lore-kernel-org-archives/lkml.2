Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1AZGlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:41:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49543
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab1AZGlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:41:35 -0500
Date: Tue, 25 Jan 2011 22:42:09 -0800 (PST)
Message-Id: <20110125.224209.183055030.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: thomas@wytron.com.tw, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        nico@fluxnic.net, netdev@vger.kernel.org
Subject: Re: [PATCH v4] smc91x: add devicetree support
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTindbigYzY0zJufpr-D25m_B5Gjqp09ZbcaN-aZ9@mail.gmail.com>
References: <20110125.194532.71125517.davem@davemloft.net>
	<1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
	<AANLkTindbigYzY0zJufpr-D25m_B5Gjqp09ZbcaN-aZ9@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 22:52:36 -0700

> On Tue, Jan 25, 2011 at 10:22 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>> v2 specify part numbers in compat as Grant suggested.
>> v3 more specific part name.
>> v4 include match table only for OF as David suggested.
>>
>>  drivers/net/smc91x.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> Looks okay to me.
> 
> Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

Applied to net-next-2.6, thanks.

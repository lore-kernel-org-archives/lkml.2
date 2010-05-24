Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab0EXSd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:33:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:3559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab0EXSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:33:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,292,1272870000"; 
   d="scan'208";a="801417656"
Subject: Re: iwl3945 bug in 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 11:33:49 -0700
Message-ID: <1274726029.2091.15160.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2010-05-22 at 23:25 -0700, Satish Eerpini wrote:

> No probe response from AP 00:1b:da:2a:a1:53 after 500ms, disconnecting.
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).
> iwl3945 0000:10:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:10:00.0: Error setting new configuration (-110).

This did not use to be an issue with 3945 and unfortunately we do not
know what is triggering it now. Please try the "Enable stuck queue
detection on 3945" patch that is attached to
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 as a
workaround.

Reinette



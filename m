Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1KKTJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:09:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50572 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1KKTJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:09:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111110857330.3557@router.home>
References: <20111109090556.GA5949@zhy>
	<201111102335.06046.kernelmail.jms@gmail.com>
	<1320980671.22361.252.camel@sli10-conroe>
	<alpine.DEB.2.00.1111110857330.3557@router.home>
Date: Fri, 11 Nov 2011 19:09:01 +0000
Message-ID: <CAAVPGOPwKV12TqwU1DcxvJTW9dsmWNiNFg4ga7PzWNgQ2M=1RQ@mail.gmail.com>
Subject: Re: INFO: possible recursive locking detected: get_partial_node() on 3.2-rc1
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably moot now but FWIW I checked Shaohua's patch too and it
got rid of the warning in my dmesg.
Cheers
Julie

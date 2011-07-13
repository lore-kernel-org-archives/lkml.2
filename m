Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1GMWYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1GMWYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:24:38 -0400
Date: Wed, 13 Jul 2011 18:24:28 -0400
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Add sanity checks to code provided by VIA
Message-ID: <20110713222428.GB14071@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
	Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <1310114243.2940.3.camel@phoenix>
 <4E1B745A.5000802@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1B745A.5000802@interia.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:08:26PM +0100, Rafał Bilski wrote:
 > Patch from VIA is forcing "e_powersaver" to accept any processor
 > >=A, but code supports only A and D.
 > Patch from VIA is forcing "e_powersaver" to support new brand, but
 > code was intended for 2 bits only.
 > Looks like model D is using 8 bits for brand. Compensate.
 > 
 > Thanks to Axel Lin for pointing it out!
 > 
 > Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>

This, and your other patch still don't apply, because your email client
has converted all tabs to spaces.

	Dave

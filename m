Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1KKFqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 00:46:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1KKFqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 00:46:38 -0500
Date: Fri, 11 Nov 2011 06:47:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111111054731.GA2292@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
 <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
 <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
 <20111110114732.GA2217@redhat.com>
 <20111110125347.GA29415@nomi.cz>
 <20111110160703.GA2775@redhat.com>
 <20111110163051.GA24533@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110163051.GA24533@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 05:30:51PM +0100, Tomáš Janoušek wrote:
> I think all those T520 and T420s models have exactly the same wireless card. I
> don't see why they wouldn't have. :-)
Well, laptops models have common mainboards, but peripheral components
might not be identical. Especially wireless card might vary from unit
to unit. For example:

T520 with iwl6300:
http://smolt.fedoraproject.org/client/show/pub_0cbc8731-47d3-4ecf-8add-aa832b34edcd
T520 with iwl1000:
http://smolt.fedoraproject.org/client/show/pub_02f601d6-7a93-4c0e-bc01-a4a95db36086 
T520 with iwl6205:
http://smolt.fedoraproject.org/client/show/pub_0232252f-75a9-4050-a69b-c8e95e00eaf2

Stanislaw

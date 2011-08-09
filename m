Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1HIPS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:18:29 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:40325 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1HIPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:18:28 -0400
Message-ID: <4E414FC0.8070700@ge.com>
Date: Tue, 09 Aug 2011 16:18:24 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] staging: vme: rename *_slot_get to *_get_slot
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch> <4E369C26.5040300@ge.com> <20110801123121.GA7130@becoht-mvanga>
In-Reply-To: <20110801123121.GA7130@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2011 15:15:07.0885 (UTC) FILETIME=[1FBC19D0:01CC56A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 13:31, Manohar Vanga wrote:
> Hi Martyn,
> 
>> If your doing vme_slot_get, then there's also vme_lm_get, vme_master_get and
>> vme_slave_get.
>>
>> Doing just this would then lead to more inconsistency in the naming and
>> wouldn't even get rid of all the functions using the *_get naming convention.
> 
> I can simply change those as well and resend :)
> 
>> I'm not sure this change is worth it.
> 
> I thought it would be worth changing this especially with the addition of bridge
> refcounting functions (which have the *_get/_set convention).
> 

The naming of the API is reasonably consistent at the moment. It looks like we
aren't going to need to export vme_bus_get and vme_bus_put based on the
conversation on patch 5. In addition to this, I've discovered that the
functions for USB are actually called usb_get_dev and usb_put_dev, so the
*_put/get convention isn't very strictly adhered to. I'd prefer to keep the
API as is.

Martyn

> --
> /manohar


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0HKFtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 01:49:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18537 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0HKFtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 01:49:17 -0400
Date: Wed, 11 Aug 2010 08:49:06 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Greg KH <gregkh@suse.de>, "Wang, Qi" <qi.wang@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "meego-dev@meego.com" <meego-dev@meego.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20100811054905.GA25199@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A28EA2273@shsmsx501.ccr.corp.intel.com>
 <003001cb38fa$fcd15db0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <003001cb38fa$fcd15db0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2010 05:48:52.0990 (UTC) FILETIME=[E12B49E0:01CB3918]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 04:14:51AM +0200, ext Masayuki Ohtake wrote:
>> > > +#define TRUE 1
>> > > +#define FALSE 0
>> >
>> > These lines should not be needed at all.
>> OKI-san, please remove them, Those definition is useless.
>
>Is the above definition is necessary?
>I can't find appropriate header file defines 'TRUE' and 'FALSE'.

it's true and false. Lowercase. UNUSED is __unused.

-- 
balbi

DefectiveByDesign.org

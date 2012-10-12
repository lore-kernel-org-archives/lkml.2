Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2JLFES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:04:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2JLFEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:04:16 -0400
Message-ID: <5077A4C8.4060100@canonical.com>
Date: Fri, 12 Oct 2012 13:04:08 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121003 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] efivarfs: Implement exclusive access for {get,set}_variable
References: <1349961551.174484.910885224391.1.gpush@pecola> <1349962956.15966.521.camel@mfleming-mobl1.ger.corp.intel.com> <20121012044901.GA17913@kroah.com>
In-Reply-To: <20121012044901.GA17913@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> Should this be backported to the stable kernels?

No, the efivarfs code that this touches was only recently committed; it 
won't be in any of the stable series.

Cheers,


Jeremy


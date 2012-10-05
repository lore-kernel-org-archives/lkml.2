Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2JELmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:42:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18333 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab2JELmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:42:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,541,1344211200"; 
   d="scan'208";a="40252901"
Message-ID: <506EC79D.5080206@citrix.com>
Date: Fri, 5 Oct 2012 12:42:21 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com> <1348243464-15903-3-git-send-email-david.vrabel@citrix.com> <5061EFB2.1080407@citrix.com> <5069D097.60606@citrix.com> <20121002200255.GA668@phenom.dumpdata.com>
In-Reply-To: <20121002200255.GA668@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/12 21:02, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 01, 2012 at 06:19:19PM +0100, David Vrabel wrote:
>> On 25/09/12 18:53, David Vrabel wrote:
>>> On 21/09/12 17:04, David Vrabel wrote:
>>>> From: David Vrabel <david.vrabel@citrix.com>
>>>>
>>>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
>>>> CLOSED.  If a backend does transition to CLOSED too soon then the
>>>> frontend may not see the CLOSING state and will not properly shutdown.
>>>>
>>>> So, treat an unexpected backend CLOSED state the same as CLOSING.
>>>
>>> Didn't handle the frontend block device being mounted. Updated patch here.
>>
>> Konrad, can you ack this updated patch if you're happy with it.
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Or should I just carry it in my for-jens-3.7 bug-fixes queue and ask
> Jen to pull it once rc0 is out?

This seems easiest, if Jan is happy with the patch.

Thanks.

David

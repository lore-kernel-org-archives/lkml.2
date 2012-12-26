Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2LZXFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 18:05:42 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:33841 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2LZXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 18:05:40 -0500
X-Greylist: delayed 2105 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 18:05:39 EST
Message-ID: <50DB82BE.6080909@gmail.com>
Date: Thu, 27 Dec 2012 00:05:34 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
References: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com> <1356524912-4736-2-git-send-email-gautam.vivek@samsung.com> <CAFp+6iEoy-d6gHBMAiNi0n+tE8iS7Hk=k92w8EWfT_r3eeN_UA@mail.gmail.com>
In-Reply-To: <CAFp+6iEoy-d6gHBMAiNi0n+tE8iS7Hk=k92w8EWfT_r3eeN_UA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/26/2012 02:56 PM, Vivek Gautam wrote:
> On Wed, Dec 26, 2012 at 5:58 PM, Vivek Gautam<gautam.vivek@samsung.com>  wrote:
>> Adding support to parse device node data in order to get
>> required properties to set pmu isolation for usb-phy.
>>
>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
>> ---
>
> Hope these changes align with what architectural changes you had suggested ?

It looks much better now, thanks! I had a few additional comments, please
see my other reply.

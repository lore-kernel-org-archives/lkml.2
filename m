Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1HZNoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:44:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52207 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1HZNn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:43:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=grL8/H5aCN6EStZq6lsfV8PVkewzU5Vp17wp83qLwtubgZv6xRHV7CF4qvlxhAaqK
	YjnGL/MOl99iSL+wGiN4g==
MIME-Version: 1.0
In-Reply-To: <4E571D66.1070302@intel.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
 <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
 <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com>
 <4E571D66.1070302@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Aug 2011 07:43:37 -0600
Message-ID: <CAErSpo5L1X49hfeJ69o_hwfuzMT6R+7TKhGbYCkyqtqVpf4tEw@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Huang Ying <ying.huang@intel.com>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:13 PM, Huang Ying <ying.huang@intel.com> wrote:
> Hi, Pavel,
>
> Sorry,  there is a minor issue in the patch.  Do you have time to try
> the updated version attached.

I think Yinghai's patch is a better approach (though it needs a changelog).

The ACPI NVS space should not be marked as "busy" by the e820 code in
the iomem_resource tree.

It's way too complicated to mess around with registering NVS space and
trying to deal with it specially in APEI.

Bjorn

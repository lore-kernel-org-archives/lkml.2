Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1C3Hqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:46:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3Hqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UEqFdyfsXicHdNAvTprmfRA7CdVV3N+mDESuYI+N9x7zXF5Pun1hyWUFesL9YZX9Sy
         V9ZGVYNjymWG0FSdsqCOspHs0XYwsBRDIum7ev+E74mRE99mtO0zOEUM9EsxEfXJ8wV4
         yhVREYx4LEuEItlYP8K5D5v863X5Drc/CbffE=
MIME-Version: 1.0
In-Reply-To: <20110329134702.GA13630@srcf.ucam.org>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
	<1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
	<1301337224-3293-3-git-send-email-seth.forshee@canonical.com>
	<AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
	<20110329134702.GA13630@srcf.ucam.org>
Date: Wed, 30 Mar 2011 07:46:50 +0000
Message-ID: <AANLkTinkVF2moqDHVmH4Wb+Frtg=qGs1-Y0w3X6CCtWN@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] eeepc-wmi: Add support for T101MT Home/Express
 Gate key
From: Corentin Chary <corentin.chary@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think this version is ok,
>>
>> Matthew, do you think this should be delayed for 2.6.40 (merge window
>> will close soon, so now it's probably time for fix only) ?
>
> Yeah, I'd lean towards this being .40 material.

Seth, I've added your (rebased) patch to my tree, I'll re-send them
with others for .40.
Thanks !


-- 
Corentin Chary
http://xf.iksaif.net

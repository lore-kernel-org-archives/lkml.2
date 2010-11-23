Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab0KWDK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:10:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47278 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KWDKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RTSMYBhabSPZ5sbpsD46BnMIOn5zdQQONMn8Gdn4aV0AsMtaECu6Zv+v7AsuUrYibG
         aboT3j6GK+lpcvs+3WDOIwyDakkuZn5J9cCP/dqze1T3LCQNYj2HPeHUytwzTQxvhOVp
         gEhK+S2tmZPQryrTuetVvjtjnKSo9bjHfbDNg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
References: <1290470763.3008.252.camel@localhost>
	<AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
Date: Mon, 22 Nov 2010 19:10:53 -0800
X-Google-Sender-Auth: fkx_7fjyAgidJlPAuHDGSXi9_TU
Message-ID: <AANLkTimCBX7FSBByeOmCp_ofYvmFeE8OF85OzB5tfjhw@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 5:37 PM, Tony Luck <tony.luck@intel.com> wrote:
> Yes - I assume here that the last "data_size" bytes will be enough
> to be useful. But in your case it most likely won't be.  You could
> lie about how much space you allow and then include some oops
> parsing code to get the vital bits out of what is passed to you. Not
> pretty - but it would work. If there are many such devices with limited
> capacity, then it would make sense to include this parsing code
> in this generic layer.

Sorry - finding the good bits from the console log is architecture
dependent ... so it can't be done (easily) in the generic code.

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0EKQb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:31:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56282 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0EKQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bqGsUnXZ3O1tamSl0xoAdCTZEwznyvohVYQGI/8+FMCVYyfgzqRy+GiPYx265s4gbd
         ruVgfvC3K6tIy8MVpyTlSr8DhK6+vFj/vHPmupgcmSkhDt6be3Qiupq4H4qvKLXc7sku
         viiO4cTIyLW4AHATLeZITUkb2hULK1Dt2ites=
Message-ID: <4BE9868B.5060601@gmail.com>
Date: Tue, 11 May 2010 09:32:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>  <alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz> <s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com> <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. peoples.. I've posted a patch
that gets everything(hopefully), working
over here.
subject: HID:magicmouse: This fixes a connection problem with the 
magicmouse.

please check it out, and let me know..

Justin P. Mattock

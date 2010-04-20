Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0DTRW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:22:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55175 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0DTRWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SJLX18qz1qjpyfLxaSsDaAo8XLrB55qGm63P2vJE3tcqUuXFWKc3+XrZWQFK1FdhVT
         cAYvlo8XSLjRuDDGDhnulXTS6nD7bnlDLyo1XNtuutKemXLQGi2GolJ+RX7onb4eyNBu
         q9RTf3RSLAjMerMkdsikRbvl6Lirf7DDY6MhQ=
MIME-Version: 1.0
In-Reply-To: <n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>
References: <4BCBFE89.9070401@ladisch.de>
	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
	 <4BCC0F10.3070208@ladisch.de>
	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>
	 <4BCCA5FD.6060002@oracle.com> <1271706161.2505.6.camel@darwin.lan>
	 <4BCD4C8D.7070805@oracle.com>
	 <n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>
Date: Tue, 20 Apr 2010 10:22:53 -0700
X-Google-Sender-Auth: 0934b2e44d88581f
Message-ID: <r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com>
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
	977d17bb174
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Henriksson <peter.henriksson@gmail.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 1:03 AM, Peter Henriksson
<peter.henriksson@gmail.com> wrote:
>> please post bootlog without patch.
>>
>> compile CONFIG_PCI_DEBUG=y and boot with "debug" in command line
>>
>> YH
>>
>
> Updated log.

please make sure your .config have CONFIG_PCI_DEBUG=y

and in the grub.conf, the append line have "debug" there.

YH

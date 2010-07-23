Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0GWKgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:36:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56972 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0GWKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=b2WwhToFDlxHCm9dcwpdDdjw7LiW6T+LZFKv5b1uvHgNs1Cqmj5+HdMf1b25LxfD/L
         evcS20Ug9Ca9yz2fSIOI9/f4BEuyHuy0dvHJtxX4BJEq177Y+I0tZKlrfwlTfA21F06K
         peWGXKxHyvwLdK/j5MLNWLO7GNrgp7JOAkrEo=
Message-ID: <4C4970BC.1070901@gmail.com>
Date: Fri, 23 Jul 2010 12:36:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Michael Jensen <emjay1988@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Fixed a macro definition
 code style issue
References: <1279865467-16522-1-git-send-email-emjay1988@gmail.com>	<4C495880.2090705@gmail.com> <AANLkTi=KTEtA57aTHEd_tzXAmK_WsX+P4jO_3TedFGFk@mail.gmail.com>
In-Reply-To: <AANLkTi=KTEtA57aTHEd_tzXAmK_WsX+P4jO_3TedFGFk@mail.gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 11:17 AM, Michael Jensen wrote:
> On Fri, Jul 23, 2010 at 6:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>
> <snip>
>> Hmm, does this compile?
>>
> I did build the comedi directory (as per Greg's "Write and submit your
> first kernel patch" video), and didn't get any errors (once I'd done
> the configuration)...
> 
> Did I miss something?

Then the macro is probably unused (or unused in your configuration).
Either way, the macro seems to be intended for use in the top-level
scope, so do { } while (0) cannot be used there.

-- 
js

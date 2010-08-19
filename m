Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0HSO04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:26:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0HSO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aX9PTQrD5Bl92Vg0r2PfGW/COPQm7AuU7W5fCFB6vCbwjSBZPseWlxSu1KDtJfwnDE
         vEXtWxMenboLLZ+nlPMgP4nUfgByuJ/oTz3ROxC2pgxvg/MdfaHQMrLzZNrzaEIsZ+vD
         meEz7PhGq/O0WA++G1kxNGSZoV4+PjejR2uzM=
Message-ID: <4C6D3E49.7080601@gmail.com>
Date: Thu, 19 Aug 2010 16:23:05 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Luis Rodriguez <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari
 One
References: <201008190001.11342.rjw@sisk.pl> <4C6CE715.4010203@kernel.org> <201008191605.08053.rjw@sisk.pl> <4C6D3D5C.7010504@kernel.org>
In-Reply-To: <4C6D3D5C.7010504@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, can you also please attach log of the BUG()?

Thanks.

-- 
tejun

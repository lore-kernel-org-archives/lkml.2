Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab1ESPF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:05:26 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:35971 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab1ESPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G5LE8mEEG9ZgmXFBnurgbz2FhAe3UN82Yr5WojEPJNI9+izJrKTpECsqdYMWuHRKKy
         2RKzYNKktusfRA6wQiZzjl4AJs2xJM/aX+kvZ2ilpyZLAL5Q3QeblnrEvlrVTGmBonAE
         70i0shC0lHuvXweGvNt7reki3Wt04so0eEJhY=
MIME-Version: 1.0
In-Reply-To: <20110519110638.GA11371@linux-mips.org>
References: <002fbbeb01a5a51fff8015af85d5d101@localhost>
	<20110519110638.GA11371@linux-mips.org>
Date: Thu, 19 May 2011 08:05:24 -0700
Message-ID: <BANLkTikouHA-Owkqji5W4sYdZ2nFrT_==g@mail.gmail.com>
Subject: Re: [PATCH v4] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 4:06 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> Who is the author of this patch, you or Dezhong Diao?

The author is Dezhong... I should have added the extra "From:" header.

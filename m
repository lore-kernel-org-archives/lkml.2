Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0ELLAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:00:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47429 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0ELLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gqvuUFC9J2wxOEB33Ber50jgZqEmG4aKuCH2AVfbblVAkIbYfpEXRstlT4es02SffR
         DmCGcXuXA8kFvKiZh7/mm/E5bPil7hVjzS0h5klUjoOKPHHswOztUOvSPkIsNngBg8w4
         I6vKuKTVSTJtPL9xb3XKevWGc9hRQts0E8aeA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimUrjqc3cVt7pDcPZ_-GSalU4mCL5TfetdT-Sel@mail.gmail.com>
References: <1273623083.2314.4.camel@localhost.localdomain>
	 <AANLkTimUrjqc3cVt7pDcPZ_-GSalU4mCL5TfetdT-Sel@mail.gmail.com>
Date: Wed, 12 May 2010 14:00:06 +0300
Message-ID: <AANLkTimOtED_QvUY4dzEckwW21D36H3x7yCxUOwQWKuQ@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 1:51 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> No need for that extra {}

Disregard that... didn't notice dmi_check_system() doesn't have an
element count argument.

-- 
Felipe Contreras

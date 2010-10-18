Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0JRUCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:02:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab0JRUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Jxl2kyRRiVE2iwi4YbSr0P1Elnz26MtTHZVeHiFhKUGpi1J6wSy5xNvU9Vpt/0vg6o
         pa937hPTxe7jSodHEBnUH5bUlhys2AixPKSXTKWIDoolqZKQNPTG0vzTQ9IbTQZaq/pu
         aFMuLuBEpOpZX0iWzu3ETEDru1BQ3gXlr4Urc=
MIME-Version: 1.0
Date: Mon, 18 Oct 2010 23:02:14 +0300
Message-ID: <AANLkTimdNFZwao_dCnAq2D=obq_Qccn-M8mNvUeoecc2@mail.gmail.com>
Subject: Latest memblock patches
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Russell is worried that the latest memblock patches or x86 are going
to affect ARM negatively. I would like to try them to find out if
that's the case.

Do you know if there's a branch available somewhere with the memblock
patches that will be merged on .37?

Cheers.

-- 
Felipe Contreras

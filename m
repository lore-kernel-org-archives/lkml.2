Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1H3Usp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:48:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9721 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1H3Uso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:48:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114101156"
Date: Tue, 30 Aug 2011 15:48:33 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v2 00/35] Hexagon: Add support for Qualcomm Hexagon
 architecture
Message-ID: <20110830204833.GA7047@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org>
 <CAOJsxLHrC1Tuf9j_Xnq9DHe15zvaB9kUWiFSxPgi4urUUO3bhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLHrC1Tuf9j_Xnq9DHe15zvaB9kUWiFSxPgi4urUUO3bhQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 11:18:24PM +0300, Pekka Enberg wrote:
> On Tue, Aug 30, 2011 at 10:07 PM, Richard Kuo <rkuo@codeaurora.org> wrote:
> > Thanks to everyone for their comments/feedback!  If I missed anything
> > or there's something else that needs cleanup, please let me know.
> 
> Are there any publicly available references for the architecture?
> Googling for "Qualcomm Hexagon" doesn't seem to find anything
> interesting.

The main developer page is at 
https://developer.qualcomm.com/hexagon-processor

The specs listed there include:

|> Hexagon V2 Programmer’s Reference Manual (80-NB419-1)
|> https://developer.qualcomm.com/file/5117/80-nb419-1ahexagonv2programmersref.pdf
|> Describes the Hexagon V2 processor architecture and instruction set.
|> 
|> Hexagon Application Binary Interface Specification (80-NB419-2)
|> https://developer.qualcomm.com/file/5119/80-nb419-2ahexagonabispec.pdf
|> Describes the application binary interface (ABI) for the Hexagon V2, V3, and V4 processor versions. Topics covered include the hardware representation of C data types, software stack configuration, parameter passing, register usage across function calls, and C++ exception handling.
|> 
|> Hexagon Virtual Machine Specification (80-NB419-3)
|> https://developer.qualcomm.com/file/5118/80-nb419-3ahexagonvirtualmachinespec.pdf
|> Describes the Hexagon Virtual Machine (HVM), a software abstraction layer which enables multiple operating systems and other clients to execute concurrently on a single Hexagon processor, through the virtualization and partitioning of physical hardware resources.
 
Access to these seems to require registration ...

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

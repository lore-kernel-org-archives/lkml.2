Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0J0TCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:02:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:47860 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0J0TCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:02:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,247,1286175600"; 
   d="scan'208";a="620905811"
Message-ID: <4CC87733.5060506@linux.intel.com>
Date: Wed, 27 Oct 2010 12:02:11 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <4CC8649F.5060408@linux.intel.com> <4CC866B0.8000802@goop.org> <4CC86B4A.2050408@linux.intel.com> <4CC87499.9050207@goop.org>
In-Reply-To: <4CC87499.9050207@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more thing: one thing in particular that is very obnoxious are hooks 
that are null on native hardware, but aren't documented.  That means 
there is no actual reference for their expected behavior.

	-hpa


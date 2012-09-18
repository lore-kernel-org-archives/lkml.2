Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2IRJfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab2IRJfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:35:17 -0400
Message-ID: <5058403B.4070208@redhat.com>
Date: Tue, 18 Sep 2012 06:34:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, mce: Enable MCA support by default
References: <1347900723-17490-1-git-send-email-bp@amd64.org> <1347900723-17490-2-git-send-email-bp@amd64.org> <3908561D78D1C84285E8C5FCA982C28F19D41BC2@ORSMSX108.amr.corp.intel.com> <20120917173204.GJ13879@aftab.osrc.amd.com>
In-Reply-To: <20120917173204.GJ13879@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-09-2012 14:32, Borislav Petkov escreveu:
> On Mon, Sep 17, 2012 at 05:30:00PM +0000, Luck, Tony wrote:
>>> MCA is the basic support for hardware error logging and reporting, and
>>> it is majorly unwise to run without it so enable machine check software
>>> support by default on x86.
>>
>> Acked-by: Tony Luck <tony.luck@intel.com>
> 
> Thanks Tony.
> 
> Will send a pull request shortly.

Sounds fine for me too. You can add my ack.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 


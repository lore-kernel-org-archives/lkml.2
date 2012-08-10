Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab2HJSwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:52:09 -0400
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:34052 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2HJSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:52:07 -0400
Message-ID: <50255849.6070307@genband.com>
Date: Fri, 10 Aug 2012 12:51:53 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Yinghai Lu <yinghai@kernel.org>, Roland Dreier <roland@kernel.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
References: <20120801133835.GH5470@ics.muni.cz> <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com> <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com> <20120801205640.GN5470@ics.muni.cz> <CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com> <20120801220802.GP5470@ics.muni.cz> <CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com> <20120803083344.GF25979@ics.muni.cz>
In-Reply-To: <20120803083344.GF25979@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2012 18:51:54.0690 (UTC) FILETIME=[35FF4A20:01CD7729]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19102.001
X-TM-AS-Result: No--10.543200-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 02:33 AM, Lukas Hejtmanek wrote:
> I also tried OFED package from Mellanox which seems to have better SR-IOV
> support (at least mlx4_ib does not complain that SR-IOV is not supported).
> However, it does not work when SR-IOV enabled:

Last I heard they were not officially providing support for SR-IOV.  Has 
anyone heard otherwise from the Mellanox folks?

Chris



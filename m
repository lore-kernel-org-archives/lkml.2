Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab2EUSNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:13:40 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:49885 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab2EUSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:13:39 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 14:13:39 EDT
Message-ID: <4FBA83AF.8000506@mni.thm.de>
Date: Mon, 21 May 2012 20:04:31 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Thunderbird/15.0a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4 released
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <CA+5PVA78ktxSPR=hCG-5isqWjUo_uzEK+TwW9AC08RQnL7ep_w@mail.gmail.com> <CA+55aFxQuNg4shK1ySZ2j0B_avYwnEyVWHqn5sOy45piYr5pRg@mail.gmail.com> <CA+5PVA44oGRooLbRmkf_VLRVhd5XX8D5mD-BgWMgt3N3zGpKgg@mail.gmail.com>
In-Reply-To: <CA+5PVA44oGRooLbRmkf_VLRVhd5XX8D5mD-BgWMgt3N3zGpKgg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there, got a build error while compiling linux-3.4:

drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
cc1: all warnings being treated as errors

This is caused by the args defined in the Makefile for the driver:
ccflags-y += -Werror

Thought this might be helpful

Greetings
Tobias Klausmann

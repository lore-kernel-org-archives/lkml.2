Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab1CaQAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:00:49 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:32846 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753342Ab1CaQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:00:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=O2SS8i6aQzqZ/9QlTVeklFXxQVMAsCG9/CEsW6AwcaKBr5aFGuHxq4bvVIKd2ypUxt7b/IyJT3F9nWmb9ViCxcPBzmv2Mh8aOoZ1Bhc9UmOSi0OEuj/7f07orpikKZqI;
Date: Thu, 31 Mar 2011 09:00:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@amd64.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, amd-nb: Rename CPU PCI id define for F4
Message-ID: <20110331090039.12358ee6@jbarnes-desktop>
In-Reply-To: <tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
References: <20110330183447.GA3668@aftab>
	<tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 07:04:41 GMT
tip-bot for Borislav Petkov <bp@amd64.org> wrote:

> Commit-ID:  cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> Gitweb:     http://git.kernel.org/tip/cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
> Author:     Borislav Petkov <bp@amd64.org>
> AuthorDate: Wed, 30 Mar 2011 20:34:47 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 31 Mar 2011 08:51:38 +0200
> 
> x86, amd-nb: Rename CPU PCI id define for F4
> 
> With increasing number of PCI function ids, add the PCI function
> id in the define name instead of its symbolic name in the BKDG
> for more clarity. This renames function 4 define.
> 

I guess I don't see how a rename is urgent, but you can add my
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

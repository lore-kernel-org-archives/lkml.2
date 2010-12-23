Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0LWLXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:23:12 -0500
Received: from smtp.nokia.com ([147.243.128.24]:53139 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0LWLXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:23:12 -0500
Message-ID: <4D13311A.3010402@nokia.com>
Date: Thu, 23 Dec 2010 13:23:06 +0200
From: Radoslaw Jablonski <ext-jablonski.radoslaw@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Radoslaw Jablonski (EXT-Comarch/Helsinki)" 
	<ext-jablonski.radoslaw@nokia.com>
Subject: Re: [PATCH] PBAP tracker-query update for addr fields
References: <1293103124-17625-1-git-send-email-ext-jablonski.radoslaw@nokia.com>
In-Reply-To: <1293103124-17625-1-git-send-email-ext-jablonski.radoslaw@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On 12/23/2010 01:18 PM, Radoslaw Jablonski (EXT-Comarch/Helsinki) wrote:
> This is needed to display many addresses of the same type
> (WORK/HOME/OTHER) in different rows in pbap pull response.
> Currently in that case all addresses of the same type
> were displayed in the same row.
> ---
>   plugins/phonebook-tracker.c |   12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/plugins/phonebook-tracker.c b/plugins/phonebook-tracker.c
> index 59221cb..b7acead 100644
> --- a/plugins/phonebook-tracker.c
> +++ b/plugins/phonebook-tracker.c
> @@ -109,7 +109,7 @@
>   "tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","		\
>   "tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","			\
>   "tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","		\
> -"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"		\
> +"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"		\
>   "WHERE {"								\
>   "?_role nco:hasPostalAddress ?aff_addr"					\
>   "}) "									\
> @@ -191,7 +191,7 @@
>   	"tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","	\
>   	"tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","		\
>   	"tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","	\
> -	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"	\
> +	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"	\
>   	"WHERE {"							\
>   	"?_role nco:hasPostalAddress ?aff_addr"				\
>   	"}) "								\
> @@ -337,7 +337,7 @@
>   	"tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","	\
>   	"tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","		\
>   	"tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","	\
> -	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"	\
> +	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"	\
>   	"WHERE {"							\
>   	"?_role nco:hasPostalAddress ?aff_addr"				\
>   	"}) "								\
> @@ -482,7 +482,7 @@
>   	"tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","	\
>   	"tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","		\
>   	"tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","	\
> -	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"	\
> +	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"	\
>   	"WHERE {"							\
>   	"?_role nco:hasPostalAddress ?aff_addr"				\
>   	"}) "								\
> @@ -621,7 +621,7 @@
>   	"tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","	\
>   	"tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","		\
>   	"tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","	\
> -	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"	\
> +	"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"	\
>   	"WHERE {"							\
>   	"?_role nco:hasPostalAddress ?aff_addr"				\
>   	"}) "								\
> @@ -813,7 +813,7 @@
>   "tracker:coalesce(nco:locality(?aff_addr), \"\"), \";\","		\
>   "tracker:coalesce(nco:region(?aff_addr), \"\"), \";\","			\
>   "tracker:coalesce(nco:postalcode(?aff_addr), \"\"), \";\","		\
> -"tracker:coalesce(nco:country(?aff_addr), \"\") ),\";\")"		\
> +"tracker:coalesce(nco:country(?aff_addr), \"\") ),\"\30\")"		\
>   "WHERE {"								\
>   "?_role nco:hasPostalAddress ?aff_addr"					\
>   "}) "									\
Sorry for spam, this should go to linux-bluetooth mailing list instead.

BR,
Radek

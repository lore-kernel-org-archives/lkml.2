Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2LCBNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:13:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15401 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2LCBN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:13:29 -0500
X-AuditID: cbfee61b-b7f616d00000319b-06-50bbfcb8256c
Message-id: <50BBFCB8.4080903@samsung.com>
Date: Mon, 03 Dec 2012 10:13:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        anish kumar <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH] EXTCON: Get and set cable properties
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
In-reply-to: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zTd0df3YHGPS0iFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MScsamAt6dCsuz/7K1MC4R6WLkZNDQsBEYseJuewQtpjEhXvr
	2boYuTiEBJYxSpz4eIIZpujuuoesEIlFjBK9R75DOV1MEhOWtbCAVPEKaEnc//meqYuRg4NF
	QFVi5+NckDAbUHj/ixtsIGFRgQiJX/0cENWCEj8m3wPrFBFQlPh0+j4TyEhmgYdMEjN2nGID
	SQgLWEq8mdUEdp2QgKPE73urmUBsTgEnicu7doE1MwvoSOxvncYGYctLbF7zFuxoFgEBiW+T
	D7GA7JUQkJXYdIAZZL6EQDe7xLl/91ghHpOUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIiQnpHYyrGiwOMQpwMCrx8D78sjtAiDWxrLgy9xCjBAez
	kgjv4gqgEG9KYmVValF+fFFpTmrxIUYfoGsnMkuJJucD4zWvJN7Q2MDY0NDS0MzU0tQAh7CS
	OG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsbJ5xo+7XlyesnkW5MF5idV9O0++W7mxgXfXZyd
	LPWMK3UP6WsWLDV2bq/exK++x2ZKy6wIBsf0V7NDXBoNe5dvnRZqvvVNQ5xpaE1DH9saXicl
	Hb4kubnmMw6qPefJ0tVYwP41bfnrd2V6dRMf1Cx/M12433TeR+f+2nuuiXNb0pxblhj/LFBi
	Kc5INNRiLipOBAD1oLTxtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd0df3YHGExfxmVxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMyYta2Au6NGtuDz7K1MD
	4x6VLkZODgkBE4m76x6yQthiEhfurWfrYuTiEBJYxCjRe+Q7K4TTxSQxYVkLC0gVr4CWxP2f
	75m6GDk4WARUJXY+zgUJswGF97+4wQYSFhWIkPjVzwFRLSjxY/I9sE4RAUWJT6fvM4GMZBZ4
	yCQxY8cpNpCEsIClxJtZTewgtpCAo8Tve6uZQGxOASeJy7t2gTUzC+hI7G+dxgZhy0tsXvOW
	eQKjwCwkO2YhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCIeya9g3FVg8Uh
	RgEORiUe3odfdgcIsSaWFVfmHmKU4GBWEuFdXAEU4k1JrKxKLcqPLyrNSS0+xOgDDICJzFKi
	yfnAZJBXEm9obGJmZGlkZmxibmyMQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA+OqRRcV
	VBYrttzd1dxz/8TRE0fiD+/8PcFfub8zcm6bo6rHHra7U2cYPDQ8ZDnXR9Jb+qzJ9OYnhfeX
	GX9V239Dtblmgnha6QarBvctXE/L9u03Ms764Wl8/rbEcW6P53oFq6fPTRX7XZyxTPv/pkY/
	Z/bgAwlRdSuenJj8d5VCMofm3aP39NWUWIozEg21mIuKEwHNKTAa5QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We discussed about this patch and then suggest some method to resolve
this issue by Myungjoo Ham. Why don't you write additional feature or
your opinion based on following patch by Myungjoo Ham?
-
http://git.kernel.org/?p=linux/kernel/git/mzx/extcon.git;a=commitdiff;h=7312b79d69a2b9f06af4f1254bc4644751e3e3ea


On 11/28/2012 06:49 AM, Jenny TC wrote:
> Existing EXTCON implementation doesn't give a mechanim to read the cable
> properties and extra states a cable needs to support. There are scenarios
> where a cable can have more than two states(CONNECT/DISCONNECT/SUSPEND/RESUME etc)
> and can have some properties associated with cables(mA)
> 
> This patch introduces interface to get and set cable properties
> from EXTCON framework. The cable property can be set either by
> the extcon cable provider or by other subsystems who know the cable
> properties using eth API extcon_cable_set_data()
> 
> When the consumer gets a notification from the extcon, it can use the
> extcon_cable_get_data() to get the cable properties irrespective of who
> provides the cable data.
> 
> This gives a single interface for setting and getting the cable properties.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  drivers/extcon/extcon-class.c |   30 ++++++++++++++++++++++++++++++
>  include/linux/extcon.h        |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index d398821..304f343 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -545,6 +545,36 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
>  }
>  EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
>  
> +/**
> + * extcon_cable_set_data() - Set the data structure for a cable
> + * @edev:	the extcon device
> + * @cable_index:	the cable index of the correspondant
> + * @type:	type of the data structure
> + * @data:
> + */
> +void extcon_cable_set_data(struct extcon_dev *edev, int cable_index,
> +			   enum extcon_cable_name type,
> +			   union extcon_cable_data data)
> +{
> +	edev->cables[cable_index].type = type;
> +	edev->cables[cable_index].data = data;
> +}
> +
> +/**
> + * extcon_cable_get_data() - Get the data structure for a cable
> + * @edev:	the extcon device
> + * @cable_index:	the cable index of the correspondant
> + * @type:	type of the data structure
> + * @data:	the corresponding data structure (e.g., regulator)
> + */
> +void extcon_cable_get_data(struct extcon_dev *edev, int cable_index,
> +			   enum extcon_cable_name *type,
> +			   union extcon_cable_data *data)
> +{
> +	*type = edev->cables[cable_index].type;
> +	*data = edev->cables[cable_index].data;
> +}
> +
>  static struct device_attribute extcon_attrs[] = {
>  	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
>  	__ATTR_RO(name),
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index 2c26c14..4556cc5 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -135,6 +135,19 @@ struct extcon_dev {
>  	struct device_attribute *d_attrs_muex;
>  };
>  
> +/* FIXME: Is this the right place for this structure definition?
> + * Do we need to move it to power_supply.h?
> + */
> +struct extcon_chrgr_cable_props {
> +	unsigned long state;
> +	int mA;
> +};

As I said, extcon provider driver didn't provide directly charging current(int mA)
and some state(unsigned long state) because the extcon provider driver(Micro
USB interface controller device or other device related to external connector) haven't
mechanism which detect dynamically charging current immediately. If you wish to
provide charging current data to extcon consumer driver or framework, you should
use regulator/power_supply framework or other method in extcon provider driver.

The patch suggested by Myungjoo Ham define following struct:
	union extcon_cable_data {
		struct regualtor *reg;  /* EXTCON_CT_REGULATOR */
		struct power_supply *psy; /* EXTCON_CT_PSY */
		struct charger_cable *charger; /* EXTCON_CT_CHARGER_MANAGER */
		/* Please add accordingly with enum extcon_cable_type */
	};

Also if you want to define 'struct extcon_chrgr_cable_props', you should certainly show how
detect dynamically charging current or state.

> +
> +union extcon_cable_data {
> +	struct extcon_chrgr_cable_props chrgr_cbl_props;
> +	/* Please add accordingly*/
> +};
> +
>  /**
>   * struct extcon_cable	- An internal data for each cable of extcon device.
>   * @edev	The extcon device
> @@ -143,6 +156,8 @@ struct extcon_dev {
>   * @attr_name	"name" sysfs entry
>   * @attr_state	"state" sysfs entry
>   * @attrs	Array pointing to attr_name and attr_state for attr_g
> + * @type:	The type of @data.
> + * @data:	The data structure representing the status and states of this cable.
>   */
>  struct extcon_cable {
>  	struct extcon_dev *edev;
> @@ -153,6 +168,11 @@ struct extcon_cable {
>  	struct device_attribute attr_state;
>  
>  	struct attribute *attrs[3]; /* to be fed to attr_g.attrs */
> +
> +	union extcon_cable_data data;
> +
> +	/* extcon cable type */
> +	enum extcon_cable_name type;
It isn't correct. The 'enum extocn_cable_name' isn't type. For example,
the list of charger cable are TA/USB/Fast Charger/Slow Charger and so on.
The charger cables are charger type so, they has EXTCON_CT_CHARGER_MANAGER
as cable type.

The patch suggested by Myungjoo Ham define following struct:
	enum extcon_cable_type {
	       EXTCON_CT_NONE = 0,
	       EXTCON_CT_REGULATOR,
	       EXTCON_CT_PSY,
	       EXTCON_CT_CHARGER_MANAGER,
	       /* Please add other related standards when needed */
	};
	
